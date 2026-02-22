class AppRoutes {
  // Public
  static const String launch = '/';
  static const String landing = '/landing';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // User Screens
  static const String main = '/main';
  static const String searchList = '/search';
  static const String searchMap = '/search/map';
  static const String equipmentId = '/equipment/:id';
  static const String booking = '/equipment/:id/book';
  static const String myRentals = '/myrentals';
  static const String favorites = '/favorites';

  static const String profile = '/profile';
  static const String settings = '/settings';

  // Owner Screens
  // prefixed with /owner
  static const String ownerDashboard = '/dashboard';
  static const String ownerEquiment = '/owner/equipment';
  static const String ownerEquimentId = '/owner/equipment/:id';
  static const String ownerEquimentIdEdit = '/owner/equipment/edit/id';
  static const String ownerEquimentNew = '/owner/equipment/new';
  static const String ownerBookings = '/bookings';

  static const String ownerProfile = '/profile';
  static const String ownerSettings = '/settings';
}
