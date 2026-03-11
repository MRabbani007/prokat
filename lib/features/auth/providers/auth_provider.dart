import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:prokat/features/auth/services/auth_secure_storage.dart';

import '../../../core/providers/api_provider.dart';
import '../services/auth_api_service.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final Dio dio = ref.watch(dioProvider); // ✅ SAME DIO
  return AuthNotifier(AuthApiService(dio), AuthSecureStorage());
});
