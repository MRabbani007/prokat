class AppRoutes {
  // Public
  static const String launch = '/';
  static const String error = '/error';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String unAuthorized = '/unauthorized';

  // Guest Screens
  static const String main = '/main'; // Landing page with limited information
  static const String helpSupport = '/help';

  // User Screens
  static const String dashboard = '/dashboard';
  static const String categories = '/categories';
  static const String searchList = '/search/list';
  static const String searchMap = '/search/map';
  static const String equipmentId = '/equipment/:id';
  static const String booking = '/equipment/:id/book';

  static const String clientRequests = '/requests';
  static const String createRequest = '/requests/create';
  static const String clientRequestHistory = '/requests/history';

  static const String clientOrders = '/orders';
  static const String clientOrdersHistory = '/history';
  static const String favorites = '/favorites';

  static const String chat = '/chat';

  static const String profile = '/profile';
  static const String settings = '/settings';

  static const String becomeOwner = '/become-owner';

  // Owner Screens
  // prefixed with /owner
  static const String ownerDashboard = '/owner/dashboard';

  static const String ownerEquiment = '/owner/equipment/list';
  static const String ownerEquimentMap = '/owner/equipment/map';
  static const String ownerEquimentId = '/owner/equipment/:id';
  static const String ownerEquimentCreate = '/owner/equipment/create';

  static const String ownerAddresses = '/owner/addresses';
  static const String ownerAddressCreate = '/owner/addresses/create';
  static const String ownerAddressEdit = '/owner/addresses/edit';
  static const String ownerAddressSelect = '/owner/addresses/select';
  static const String ownerAddressMap = '/owner/addresses/map';

  static const String ownerRequests = '/owner/requests';

  static const String ownerBookings = '/owner/bookings';
  static const String ownerBookingsHistory = '/owner/bookings/history';

  static const String ownerProfile = '/owner/profile';
  static const String ownerSettings = '/owner/settings';

  static const String ownerPayment = '/owner/payment';
  static const String ownerRegistration = '/owner/registration';

  static const String ownerChatList =
      '/owner/chat'; // 

  static const String chatDetail = ':id';
  static const String chatInfo = 'info';
}
