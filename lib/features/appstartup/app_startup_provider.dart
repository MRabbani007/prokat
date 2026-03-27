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

  AppStartupController(this.ref) : super(AppStartupState.loading) {
    init();
  }

  Future<void> init() async {
    try {
      final auth = ref.read(authProvider.notifier);

      /// 1️⃣ Restore session
      final session = await auth.restoreSession();

      if (session == null) {
        state = AppStartupState.guest;
        return;
      }

      /// 2️⃣ Refresh / validate
      final isValid = await auth.refreshSession();

      if (!isValid) {
        state = AppStartupState.guest;
        return;
      }

      /// 3️⃣ Fetch user profile
       await ref
          .read(userProfileProvider.notifier).getUserProfile();
  
  final profile = ref.watch(userProfileProvider).userProfile;

      if (profile == null) {
        state = AppStartupState.guest;
        return;
      }

      /// 4️⃣ Load shared data
      await Future.wait([
        ref.read(categoriesProvider.notifier).getCategories(),
        ref.read(locationProvider.notifier).loadAddresses(),
      ]);

      /// 5️⃣ Role-based loading
      if (profile.role == "owner") {
        await Future.wait([
          ref.read(bookingProvider.notifier).getOwnerBookings(),
          ref.read(equipmentProvider.notifier).getOwnerEquipment(),
        ]);

        state = AppStartupState.owner;
      } else {
        await Future.wait([
          ref.read(bookingProvider.notifier).getUserBookings(),
          ref.read(requestProvider.notifier).getUserRequests(),
        ]);

        state = AppStartupState.renter;
      }
    } catch (e) {
      state = AppStartupState.error;
    }
  }
}
