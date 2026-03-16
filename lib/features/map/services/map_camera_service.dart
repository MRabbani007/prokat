import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapCameraService {

  static Future<void> flyTo(
    MapboxMap map,
    double lat,
    double lng, {
    double zoom = 16,
  }) async {
    await map.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(lng, lat),
        ),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 1200),
    );
  }

  static Future<void> zoomIn(MapboxMap map) async {
    final camera = await map.getCameraState();
    await map.setCamera(
      CameraOptions(zoom: camera.zoom + 1),
    );
  }

  static Future<void> zoomOut(MapboxMap map) async {
    final camera = await map.getCameraState();
    await map.setCamera(
      CameraOptions(zoom: camera.zoom - 1),
    );
  }
}