import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/auth/providers/auth_state.dart';

import 'package:prokat/features/layout/main_scaffold.dart';

/// screens
import 'package:prokat/screens/auth/forgot_password_screen.dart';
import 'package:prokat/screens/auth/login_screen.dart';
import 'package:prokat/screens/auth/register/register_screen.dart';
import 'package:prokat/screens/user/launch/launch_screen.dart';
import 'package:prokat/screens/user/landing/landing_screen.dart';

import 'package:prokat/screens/user/main/main_screen.dart';
import 'package:prokat/screens/user/map/map_screen.dart';
import 'package:prokat/screens/user/search/search_list_screen.dart';
import 'package:prokat/screens/user/equipment/equipment_id_screen.dart';
import 'package:prokat/screens/user/booking/booking_screen.dart';
import 'package:prokat/screens/user/booking/my_rentals_screen.dart';
import 'package:prokat/screens/user/favorites/favorites_screen.dart';
import 'package:prokat/screens/user/profile/profile_screen.dart';
import 'package:prokat/screens/user/settings/settings_screen.dart';

import 'package:prokat/screens/owner/dashboard/owner_dashboard_screen.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_screen.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_new.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_id_screen.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_id_edit_screen.dart';
import 'package:prokat/screens/owner/booking/owner_booking_screen.dart';
import 'package:prokat/screens/owner/profile/owner_profile_screen.dart';
import 'package:prokat/screens/owner/settings/owner_settings_screen.dart';

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.launch,

    /// 🔐 AUTH GUARD
    redirect: (context, state) {
      final auth = ref.read(authProvider);

      final loggedIn = auth.status == AuthStatus.authenticated;
      final role = auth.session?.user.role;

      final location = state.uri.toString();

      /// protect profile/settings
      final needsUserAuth =
          location == AppRoutes.profile || location == AppRoutes.settings;

      if (needsUserAuth && !loggedIn) {
        return AppRoutes.login;
      }

      /// protect owner routes
      final isOwnerRoute = location.startsWith("/owner");

      if (isOwnerRoute) {
        if (!loggedIn) {
          return AppRoutes.login;
        }

        if (role != "OWNER") {
          return AppRoutes.main;
        }
      }

      return null;
    },

    routes: [
      /// 🚀 PUBLIC
      GoRoute(path: AppRoutes.launch, builder: (_, _) => const LaunchScreen()),
      GoRoute(
        path: AppRoutes.landing,
        builder: (_, _) => const LandingScreen(),
      ),

      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),

      /// APP LAYOUT
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          /// 👤 USER
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.main,
                builder: (_, _) => const MainScreen(),
              ),

              GoRoute(
                path: AppRoutes.searchList,
                name: 'search',
                builder: (context, state) {
                  final query = state.uri.queryParameters['q'] ?? '';
                  final category = state.uri.queryParameters['category'] ?? '';
                  final city =
                      state.uri.queryParameters['city'] ?? 'All Locations';

                  return SearchListScreen(
                    q: query,
                    category: category,
                    city: city,
                  );
                },
              ),

              GoRoute(
                path: AppRoutes.searchMap,
                builder: (_, _) => const MapScreen(),
              ),

              GoRoute(
                path: '/equipment/:id',
                name: 'equipment_details',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return EquipmentIdScreen(equipmentId: id);
                },
                routes: [
                  GoRoute(
                    path: 'book',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return BookingScreen(equipmentId: id);
                    },
                  ),
                ],
              ),

              GoRoute(
                path: AppRoutes.myRentals,
                builder: (_, _) => const MyRentalsScreen(),
              ),

              GoRoute(
                path: AppRoutes.favorites,
                builder: (_, _) => const FavoritesScreen(),
              ),

              /// 🔒 PROTECTED
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),

              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),

          /// 🏗 OWNER
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.ownerDashboard,
                builder: (_, _) => const OwnerDashboardScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerEquiment,
                builder: (_, _) => const OwnerEquipmentScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerEquimentNew,
                builder: (_, _) => const OwnerEquipmentNew(),
              ),
              GoRoute(
                path: AppRoutes.ownerEquimentId,
                builder: (_, _) => OwnerEquipmentIdScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerEquimentIdEdit,
                builder: (_, _) => OwnerEquipmentIdEditScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerBookings,
                builder: (_, _) => const OwnerBookingScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerProfile,
                builder: (_, _) => const OwnerProfileScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerSettings,
                builder: (_, _) => const OwnerSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
