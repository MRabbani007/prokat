import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:prokat/data/mock_equipment.dart';
import '../../../models/equipment.dart';
import 'widgets/equipment_sheet.dart';
import 'widgets/map_controls.dart';

enum MapMode {
  browseEquipment, // rental map
  pickLocation, // select address
  ownerPlaceEquipment,
}

class MobileMapScreen extends StatefulWidget {
  final MapMode mode;
  final Function(Position)? onLocationPicked;

  const MobileMapScreen({super.key, required this.mode, this.onLocationPicked});

  @override
  State<MobileMapScreen> createState() => _MobileMapScreenState();
}

class _MobileMapScreenState extends State<MobileMapScreen> {
  MapboxMap? _map;
  geo.Position? _userPosition;
  double _zoom = 14;
  PointAnnotationManager? _annotationManager;
  CameraOptions? _initialCamera;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Widget _centerPin() {
    if (widget.mode != MapMode.pickLocation) return const SizedBox();

    return const Center(
      child: Icon(Icons.location_pin, size: 48, color: Colors.red),
    );
  }

  Future<void> _loadLocation() async {
    /*
  final pos = await geo.Geolocator.getCurrentPosition(
    desiredAccuracy: geo.LocationAccuracy.high,
  );
  */
    if (!mounted) return;

    final pos = geo.Position(
      longitude: 51.924716,
      latitude: 47.095101,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    _userPosition = pos;

    _initialCamera = CameraOptions(
      center: Point(coordinates: Position(pos.longitude, pos.latitude)),
      zoom: 14, // 👈 IMPORTANT
    );

    setState(() {});

    // Load globe and set position
    // if (mounted) setState(() => _userPosition = pos);
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _map = mapboxMap;

    _map!.location.updateSettings(
      LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );

    _map!.gestures.updateSettings(
      GesturesSettings(
        rotateEnabled: true,
        pitchEnabled: true,
        scrollEnabled: true,
        pinchToZoomEnabled: true,
        // zoomEnabled: true,
        doubleTapToZoomInEnabled: true,
        doubleTouchToZoomOutEnabled: true,
      ),
    );
  }

  void _onCameraChanged(CameraChangedEventData data) {
    _zoom = data.cameraState.zoom;
  }

  /// This is the most stable place to add markers and images
  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    try {
      if (_map == null) return;

      // 1. Load Bytes from assets path
      final ByteData bytes = await rootBundle.load(
        'assets/images/icons/truck_topview.png',
      );
      final Uint8List list = bytes.buffer.asUint8List();

      // 2. DECODE to find actual dimensions (Prevents memory-mismatch crash)
      final ui.Codec codec = await ui.instantiateImageCodec(list);
      final ui.FrameInfo fi = await codec.getNextFrame();
      final int w = fi.image.width;
      final int h = fi.image.height;

      // 3. Register the image with the map style
      // Use the 7-argument version for Mapbox Maps Flutter 2026/latest
      final mbxImage = MbxImage(width: w, height: h, data: list);

      await _map!.style.addStyleImage(
        'tractor-icon',
        1.0,
        mbxImage,
        false,
        [],
        [],
        null,
      );

      // 4. Initialize Point Manager
      _annotationManager = await _map!.annotations
          .createPointAnnotationManager();
      _annotationManager!.tapEvents(onTap: _onAnnotationTapped);

      // 5. Add markers
      if (widget.mode == MapMode.browseEquipment) {
        await _addEquipmentMarkers();
      }

      if (widget.mode == MapMode.ownerPlaceEquipment) {
        // Show draggable marker later
      }

      _moveToUserOnce();
    } catch (e) {
      debugPrint("Mapbox Loading Error: $e");
    }
  }

  Future<void> _addEquipmentMarkers() async {
    if (_annotationManager == null) return;

    final List<PointAnnotationOptions> optionsList = [];
    double iconSizeForZoom(double zoom) {
      if (zoom < 11) return 0.6;
      if (zoom < 13) return 0.8;
      if (zoom < 15) return 0.9;
      return 1;
    }

    for (final equipment in mockEquipment) {
      optionsList.add(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(equipment.longitude, equipment.latitude),
          ),
          // We use the ID 'tractor-icon' we registered in step 2
          iconImage: 'tractor-icon',
          iconSize: iconSizeForZoom(_zoom),
          // Optional: Tint the tractor red if unavailable (Requires SDF icon,
          // but for now let's keep it simple)
          iconOpacity: equipment.available ? 1.0 : 0.5,
          customData: {'id': equipment.id},
        ),
      );
    }

    await _annotationManager!.createMulti(optionsList);
  }

  void _onAnnotationTapped(PointAnnotation annotation) {
    final equipmentId = annotation.customData?['id'];
    if (equipmentId == null) return;
    final equipment = mockEquipment.firstWhere((e) => e.id == equipmentId);
    _showEquipmentModal(equipment);
  }

  void _moveToUserOnce() {
    if (_map == null || _userPosition == null) return;

    _map!.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(
            _userPosition!.longitude,
            _userPosition!.latitude,
          ),
        ),
        zoom: _zoom,
      ),
    );
  }

  Future<void> _moveCamera() async {
    if (_map == null) return;

    // Get CURRENT camera state (center + zoom)
    final cameraState = await _map!.getCameraState();

    _map!.setCamera(
      CameraOptions(
        center: cameraState.center, // 👈 keep current center
        zoom: _zoom, // 👈 only change zoom
        bearing: cameraState.bearing,
        pitch: cameraState.pitch,
      ),
    );
  }

  Future<void> _animateZoom(double newZoom) async {
    if (_map == null) return;

    final state = await _map!.getCameraState();

    _zoom = newZoom;

    _map!.flyTo(
      CameraOptions(
        center: state.center, // ✅ preserve pan position
        zoom: _zoom,
        bearing: state.bearing,
        pitch: state.pitch,
      ),
      MapAnimationOptions(
        duration: 300, // ms (200–400 feels best)
        startDelay: 0,
        // easing: MapAnimationEasing.easeOut,
      ),
    );
  }

  void _showEquipmentModal(EquipmentModel equipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EquipmentSheet(equipment: equipment),
    );
  }

  Future<void> _confirmPickedLocation() async {
    if (_map == null) return;

    final state = await _map!.getCameraState();
    final center = state.center!.coordinates;

    widget.onLocationPicked?.call(center);
  }

  Future<String?> reverseGeocode(Position position) async {
    // final response = await MapboxSearch.reverseGeocode(
    //   ReverseGeocodeOptions(
    //     center: position,
    //     limit: 1,
    //   ),
    // );

    // return response.isNotEmpty
    //     ? response.first.placeName
    //     : null;
  }

  @override
  Widget build(BuildContext context) {
    // if (_userPosition == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }
    if (_initialCamera == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('map'),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
            cameraOptions: _initialCamera, // Start map on initial Camera
            onStyleLoadedListener: _onStyleLoaded,
            onCameraChangeListener: _onCameraChanged,
          ),
          _centerPin(),
          MapControls(
            onZoomIn: () => _animateZoom(_zoom + 1),
            onZoomOut: () => _animateZoom(_zoom - 1),
            onChangeLocation: () async {
              await _loadLocation();
              _moveCamera();
            },
          ),
        ],
      ),
    );
  }
}
