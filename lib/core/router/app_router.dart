import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/core/router/refresh_stream.dart';
import 'package:prokat/features/appstartup/app_startup_provider.dart';
import 'package:prokat/features/appstatic/screens/error_screen.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/auth/screens/register_screen.dart';
import 'package:prokat/features/bookings/screens/equipment_booking_screen.dart';
import 'package:prokat/features/bookings/screens/renter_bookings_screen.dart';
import 'package:prokat/features/categories/screens/categories_screen.dart';
import 'package:prokat/features/equipment/screens/equipment_id_screen.dart';
import 'package:prokat/features/equipment/screens/equipment_list_screen.dart';
import 'package:prokat/features/layout/main_scaffold.dart';
import 'package:prokat/features/auth/screens/forgot_password_screen.dart';
import 'package:prokat/features/auth/screens/login_screen.dart';
import 'package:prokat/features/locations/screens/renter_addresses_screen.dart';
import 'package:prokat/features/map/screens/map_owner_pin_location_screen.dart';
import 'package:prokat/features/map/screens/map_renter_equipment_screen.dart';
import 'package:prokat/features/map/screens/map_renter_pin_address_screen.dart';
import 'package:prokat/features/owner/addresses/screens/owner_address_create_screen.dart';
import 'package:prokat/features/owner/addresses/screens/owner_address_edit_screen.dart';
import 'package:prokat/features/owner/addresses/screens/owner_addresses_screen.dart';
import 'package:prokat/features/owner/addresses/screens/owner_select_address_screen.dart';
import 'package:prokat/features/bookings/screens/owner_bookings_history_screen.dart';
import 'package:prokat/features/bookings/screens/owner_bookings_screen.dart';
import 'package:prokat/features/equipment/screens/owner_equipment_detail_screen.dart';
import 'package:prokat/features/equipment/screens/create_equipment_screen.dart';
import 'package:prokat/features/equipment/screens/owner_equipment_list_screen.dart';
import 'package:prokat/features/requests/screens/owner_requests_screen.dart';
import 'package:prokat/features/requests/screens/create_request_screen.dart';
import 'package:prokat/features/requests/screens/renter_requests_history_screen.dart';
import 'package:prokat/features/requests/screens/renter_requests_screen.dart';
import 'package:prokat/features/user/screens/owner_dashboard_screen.dart';
import 'package:prokat/features/user/screens/owner_profile_screen.dart';
import 'package:prokat/features/user/screens/owner_settings_screen.dart';
import 'package:prokat/features/user/screens/user_dashboard_screen.dart';
import 'package:prokat/features/user/screens/user_profile_screen.dart';
import 'package:prokat/features/user/screens/user_settings_screen.dart';
import 'package:prokat/features/appstatic/screens/launch_screen.dart';
import 'package:prokat/features/appstatic/screens/main_screen.dart';
import 'package:prokat/features/favorites/screens/favorites_screen.dart';

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.launch,

    /// 🔁 REFRESH WHEN AUTH CHANGES
    refreshListenable: GoRouterRefreshStream(
      // ref.watch(authProvider.notifier).stream,
      ref.watch(appStartupProvider.notifier).stream,
    ),

    /// 🔐 AUTH GUARD
    redirect: (context, state) {
      final startupState = ref.read(appStartupProvider);

      if (startupState == AppStartupState.loading) {
        return '/launch';
      } else if (startupState == AppStartupState.error) {
        return '/error';
      }

      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final role = authState.session?.user?.role;

      final location = state.matchedLocation;

      /// 🔒 ROUTES THAT REQUIRE LOGIN
      final requiresAuth = <String>[
        AppRoutes.profile,
        AppRoutes.settings,
        // AppRoutes.favorites,
        // AppRoutes.myRentals,
      ].any((path) => location.startsWith(path));

      /// 🔒 BOOKING (nested route)
      final isBookingRoute = location.contains('/book');

      /// 🔒 OWNER ROUTES
      final isOwnerRoute = location.startsWith('/owner');

      /// 🔐 USER AUTH GUARD
      if (!isLoggedIn && (requiresAuth || isBookingRoute || isOwnerRoute)) {
        return AppRoutes.login;
      }

      /// 🏗 OWNER ROLE GUARD
      if (isOwnerRoute && role != 'OWNER') {
        return AppRoutes.main;
      }

      /// 🚫 BLOCK AUTH SCREENS WHEN LOGGED IN
      if (isLoggedIn &&
          (location == AppRoutes.login || location == AppRoutes.register)) {
        return AppRoutes.main;
      }

      return null;
    },

    routes: [
      /// 🚀 PUBLIC
      GoRoute(path: AppRoutes.launch, builder: (_, _) => const LaunchScreen()),
      GoRoute(path: AppRoutes.error, builder: (_, _) => const ErrorScreen()),

      /// 🧱 MAIN APP
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          /// 👤 USER
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.login,
                builder: (_, _) => const LoginScreen(),
              ),
              GoRoute(
                path: AppRoutes.register,
                builder: (_, _) => const RegisterScreen(),
              ),
              GoRoute(
                path: AppRoutes.forgotPassword,
                builder: (_, _) => const ForgotPasswordScreen(),
              ),
              GoRoute(
                path: AppRoutes.main,
                builder: (_, _) => const MainScreen(),
              ),
              GoRoute(
                path: AppRoutes.categories,
                builder: (_, _) => const CategoriesScreen(),
              ),
              GoRoute(
                path: AppRoutes.searchList,
                builder: (context, state) {
                  final q = state.uri.queryParameters['q'] ?? '';
                  final category = state.uri.queryParameters['category'] ?? '';
                  final city =
                      state.uri.queryParameters['city'] ?? 'All Locations';

                  return EquipmentListScreen(
                    q: q,
                    category: category,
                    city: city,
                  );
                },
              ),
              // Map screen which displays equipment for rent
              GoRoute(
                path: AppRoutes.searchMap,
                builder: (_, _) => const MapRenterEquipmentScreen(),
              ),
              // display equipment details in full screen
              GoRoute(
                path: '/equipment/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return EquipmentIdScreen(equipmentId: id);
                },
                routes: [
                  // Screen for creating a booking on an equipment
                  GoRoute(
                    path: 'book',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EquipmentBookingScreen(equipmentId: id); //
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/addresses',
                builder: (context, state) {
                  return RenterAddressesScreen();
                },
                routes: [
                  // Screen for creating a booking on an equipment
                  GoRoute(
                    path: 'pintomap',
                    builder: (context, state) {
                      return MapRenterPinAddressScreen(); //
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/dashboard',
                builder: (context, state) {
                  return UserDashboardPage(); //
                },
              ),
              GoRoute(
                path: '/requests',
                builder: (context, state) {
                  return RenterRequestsScreen();
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) {
                      return CreateRequestScreen();
                    },
                  ),
                  GoRoute(
                    path: 'history',
                    builder: (context, state) {
                      return RenterRequestsHistoryScreen();
                    },
                  ),
                ],
              ),
              GoRoute(
                path: AppRoutes.myOrders,
                builder: (_, _) => const RenterBookingsScreen(),
              ),
              GoRoute(
                path: AppRoutes.favorites,
                builder: (_, _) => const FavoritesScreen(),
              ),
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const UserProfileScreen(),
              ),
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const UserSettingsScreen(),
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
                builder: (_, _) => const OwnerEquipmentListScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerEquimentCreate,
                builder: (_, _) => const CreateEquipmentScreen(),
              ),
              GoRoute(
                path: AppRoutes.ownerEquimentId,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return OwnerEquipmentDetailScreen(equipmentId: id);
                },
              ),
              //
              // Owner Addresses
              //
              GoRoute(
                path: AppRoutes.ownerAddresses,
                builder: (context, state) {
                  return OwnerAddressesScreen();
                },
              ),
              GoRoute(
                path: AppRoutes.ownerAddressMap,
                builder: (context, state) {
                  final equipmentId =
                      state.uri.queryParameters['equipmentId'] ?? "";
                  return MapOwnerPinLocationScreen(equipmentId: equipmentId);
                },
              ),
              GoRoute(
                path: AppRoutes.ownerAddressCreate,
                builder: (context, state) {
                  return OwnerAddressCreateScreen();
                },
              ),
              GoRoute(
                path: AppRoutes.ownerAddressSelect,
                builder: (context, state) {
                  return OwnerSelectAddressScreen();
                },
              ),
              GoRoute(
                path: AppRoutes.ownerAddressEdit,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return OwnerAddressEditScreen(id: id);
                },
              ),
              //
              // Owner Bookings
              //
              GoRoute(
                path: AppRoutes.ownerBookings,
                builder: (_, _) => const OwnerBookingsScreen(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) {
                      return OwnerBookingHistoryScreen();
                    },
                  ),
                ],
              ),
              GoRoute(
                path: AppRoutes.ownerRequests,
                builder: (_, _) => const OwnerRequestsScreen(),
              ),
              //
              // Owner Profile
              //
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
