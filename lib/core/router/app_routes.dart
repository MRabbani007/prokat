class AppRoutes {
  // Public
  static const String launch = '/';
  static const String error = '/error';
  static const String landing = '/landing';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Guest Screens
  static const String main = '/main'; // Landing page with limited information

  // User Screens
  static const String dashboard = '/dashboard';
  static const String categories = '/categories';
  static const String searchList = '/search/list';
  static const String searchMap = '/search/map';
  static const String equipmentId = '/equipment/:id';
  static const String booking = '/equipment/:id/book';
  static const String myRequests = '/requests';
  static const String createRequest = '/requests/create';
  static const String myOrders = '/myOrders';
  static const String favorites = '/favorites';

  static const String profile = '/profile';
  static const String settings = '/settings';

  // Owner Screens
  // prefixed with /owner
  static const String ownerDashboard = '/owner/dashboard';

  static const String ownerEquiment = '/owner/equipment/list';
  static const String ownerEquimentMap = '/owner/equipment/map';
  static const String ownerEquimentId = '/owner/equipment/:id';
  static const String ownerEquimentIdEdit = '/owner/equipment/:id/edit';
  static const String ownerEquimentCreate = '/owner/equipment/create';
  static const String ownerAddresses = '/owner/addresses';
  static const String ownerAddressCreate = '/owner/addresses/create';
  static const String ownerAddressEdit = '/owner/addresses/edit';
  static const String ownerAddressSelect = '/owner/addresses/select';
  static const String ownerAddressMap = '/owner/addresses/map';

  static const String ownerRequests = '/owner/requests';

  static const String ownerBookings = '/owner/bookings';

  static const String ownerProfile = '/owner/profile';
  static const String ownerSettings = '/owner/settings';
}
