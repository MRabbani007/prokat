import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/requests/state/request_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

enum AppStartupState { loading, guest, otp, client, owner, error }

final appStartupProvider =
    StateNotifierProvider<AppStartupController, AppStartupState>((ref) {
      return AppStartupController(ref);
    });

class AppStartupController extends StateNotifier<AppStartupState> {
  final Ref ref;
  bool _initialized = false;
  bool _isInitializing = false;

  AppStartupController(this.ref) : super(AppStartupState.loading) {
    Future.microtask(() async {
      // final authState = ref.read(authProvider);

      // TODO: Remove Duplicate call
      // if (authState.session != null) {
      // await init();
      // } else {
      // state = AppStartupState.guest;
      // }
    });
  }

  Future<void> reloadApp() async {
    state = await loadAppData();
  }

  Future<AppStartupState> loadAppData() async {
    /// Fetch profile
    await ref.read(userProfileProvider.notifier).getUserProfile();

    final profile = ref.read(userProfileProvider).userProfile;

    if (profile == null) {
      return AppStartupState.guest;
    }

    /// Load Selected Service
    final selectedCategory = profile.selectedCategoryId;
    final categories = ref.read(categoriesProvider).categories;

    final foundCategory = categories
        .where((cat) => cat.id == selectedCategory)
        .firstOrNull;

    if (foundCategory != null) {
      ref.read(categoriesProvider.notifier).selectCategory(foundCategory);
    }

    // Load Selected City / Region
    final selectedCity = profile.city;
    if (selectedCity != null) {
      ref.read(locationProvider.notifier).selectCity(selectedCity);
    }

    /// Shared data
    await Future.wait([
      ref.read(locationProvider.notifier).getRenterLocations(),
    ]);

    /// Role-based
    if (profile.role?.toLowerCase() == "owner") {
      await Future.wait([
        ref.read(bookingProvider.notifier).getOwnerBookings(),
        ref.read(equipmentProvider.notifier).getOwnerEquipment(),
        ref.read(locationProvider.notifier).getOwnerLocations(),
      ]);

      return AppStartupState.owner;
    } else {
      await Future.wait([
        ref.read(bookingProvider.notifier).getUserBookings(),
        ref.read(requestProvider.notifier).getUserRequests(),
      ]);

      return AppStartupState.client;
    }
  }

  Future<void> init() async {
    if (_initialized || _isInitializing) return;

    _isInitializing = true;

    try {
      final start = DateTime.now();

      final elapsed = DateTime.now().difference(start);
      const minDuration = Duration(milliseconds: 800);

      await ref.read(categoriesProvider.notifier).getCategories();

      final auth = ref.read(authProvider.notifier);

      /// Restore session
      final session = await auth.restoreSession();

      // If no session
      if (session == null) {
        final otpSession = await auth.restoreOtpSession();

        // check if there is OTP session
        if (otpSession == true) {
          state = AppStartupState.otp; // ✅ go to login/otp screen
        } else {
          state = AppStartupState.guest;
        }

        if (elapsed < minDuration) {
          await Future.delayed(minDuration - elapsed);
        }

        return;
      }

      /// Refresh / validate
      final isValid = await auth.refreshSession();

      if (!isValid) {
        state = AppStartupState.guest;

        if (elapsed < minDuration) {
          await Future.delayed(minDuration - elapsed);
        }

        return;
      }

      state = await loadAppData();

      _initialized = true;
    } catch (e) {
      state = AppStartupState.error;
    } finally {
      _isInitializing = false;
    }
  }
}
