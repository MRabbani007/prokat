import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/layout/main_scaffold.dart';

// Auth & public
import 'package:prokat/screens/auth/forgot_password_screen.dart';
import 'package:prokat/screens/auth/login_screen.dart';
import 'package:prokat/screens/auth/register_screen.dart';
import 'package:prokat/screens/user/launch/launch_screen.dart';
import 'package:prokat/screens/user/landing/landing_screen.dart';

// User
import 'package:prokat/screens/user/main/main_screen.dart';
import 'package:prokat/screens/user/map/map_screen.dart';
import 'package:prokat/screens/user/search/search_list_screen.dart';
import 'package:prokat/screens/user/equipment/equipment_id_screen.dart';
import 'package:prokat/screens/user/booking/booking_screen.dart';
import 'package:prokat/screens/user/booking/my_rentals_screen.dart';
import 'package:prokat/screens/user/favorites/favorites_screen.dart';
import 'package:prokat/screens/user/profile/profile_screen.dart';
import 'package:prokat/screens/user/settings/settings_screen.dart';

// Owner
import 'package:prokat/screens/owner/dashboard/owner_dashboard_screen.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_screen.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_new.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_id_screen.dart';
import 'package:prokat/screens/owner/equipment/owner_equipment_id_edit_screen.dart';
import 'package:prokat/screens/owner/booking/owner_booking_screen.dart';
import 'package:prokat/screens/owner/profile/owner_profile_screen.dart';
import 'package:prokat/screens/owner/settings/owner_settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.launch,
  routes: [
    /// 🚀 PUBLIC / AUTH (NO LAYOUT)
    GoRoute(path: AppRoutes.launch, builder: (_, _) => const LaunchScreen()),
    GoRoute(path: AppRoutes.landing, builder: (_, _) => const LandingScreen()),

    // Auth Screens
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, _) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, _) => const ForgotPasswordScreen(),
    ),

    /// 🧱 APPLICATION LAYOUT
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        /// 👤 USER BRANCH
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
                // Extract parameters with default empty strings
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
              builder: (context, state) => const MapScreen(),
            ),
            GoRoute(
              path: '/equipment/:id',
              name: 'equipment_details',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return EquipmentIdScreen(equipmentId: id);
              },
              routes: [
                // This makes the URL: /equipment/cat-320/book
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

        /// 🏗 OWNER BRANCH
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
              builder: (_, state) =>
                  OwnerEquipmentIdScreen(), //id: state.pathParameters['id']!
            ),
            GoRoute(
              path: AppRoutes.ownerEquimentIdEdit,
              builder: (_, state) =>
                  OwnerEquipmentIdEditScreen(), //id: state.pathParameters['id']!
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
