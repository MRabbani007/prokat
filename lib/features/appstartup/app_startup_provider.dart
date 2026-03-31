import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

enum AppStartupState { loading, guest, renter, owner, error }

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
      final authState = ref.read(authProvider);

      /// ✅ If already logged in → run init
      if (authState.session != null) {
        await init();
      } else {
        /// ✅ Otherwise don't run init at all
        state = AppStartupState.guest;
      }
    });
  }

  Future<void> reloadApp() async {
    // state = AppStartupState.loading;
    state = await loadAppData();
  }

  Future<AppStartupState> loadAppData() async {
    /// Fetch profile
    await ref.read(userProfileProvider.notifier).getUserProfile();

    final profile = ref.read(userProfileProvider).userProfile;

    if (profile == null) {
      return AppStartupState.guest;
    }

    /// Category restore
    final selectedCategory = profile.selectedCategoryId;
    final categories = ref.read(categoriesProvider).categories;

    final foundCategory = categories
        .where((cat) => cat.id == selectedCategory)
        .firstOrNull;

    if (foundCategory != null) {
      ref.read(categoriesProvider.notifier).selectCategory(foundCategory);
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

      return AppStartupState.renter;
    }
  }

  Future<void> init() async {
    print("startup_init");
    if (_initialized || _isInitializing) return;

    _isInitializing = true;

    try {
      print("startup_initializing");
      await ref.read(categoriesProvider.notifier).getCategories();
      print("startup_categories");

      final auth = ref.read(authProvider.notifier);

      /// Restore session
      final session = await auth.restoreSession();

      print("startup_session");
      print(session?.toJson());

      if (session == null) {
        state = AppStartupState.guest;
        return;
      }

      /// Refresh / validate
      final isValid = await auth.refreshSession();

      if (!isValid) {
        state = AppStartupState.guest;
        return;
      }

      state = await loadAppData();

      _initialized = true;
    } catch (e) {
      print(e.toString());
      state = AppStartupState.error;
    } finally {
      _isInitializing = false;
    }
  }
}
