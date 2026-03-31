import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/otp_field.dart';

class OtpVerificationForm extends ConsumerStatefulWidget {
  final String phone;
  final Function(String?) onError;

  const OtpVerificationForm({
    super.key,
    required this.phone,
    required this.onError,
  });

  @override
  ConsumerState<OtpVerificationForm> createState() =>
      _OtpVerificationFormState();
}

class _OtpVerificationFormState extends ConsumerState<OtpVerificationForm> {
  final otpController = TextEditingController();

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    // 1. Frontend Validation
    if (otp.isEmpty) {
      widget.onError("Please enter the verification code");
      return;
    }

    if (otp.length != 6) {
      widget.onError("The OTP must be 6 digits");
      return;
    }

    // Clear previous errors
    widget.onError(null);

    try {
      final success = await ref
          .read(authProvider.notifier)
          .verifyOtp(widget.phone, otp);

      if (success != null) {
        if (mounted) context.go('/search/map');
      } else {
        widget.onError("Invalid or expired OTP");
      }
    } catch (e) {
      // 2. Handle Backend/Network Errors
      widget.onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Column(
      children: [
        const SizedBox(height: 20),

        Text(
          "Enter the 6-digit code sent to ${widget.phone}",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
        Text(
          widget.phone,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 24),

        OtpField(controller: otpController),

        const SizedBox(height: 32),

        AuthButton(
          loading: authState.isLoading,
          text: "Verify Otp",
          loadingText: "Verifying...",
          onPressed: verifyOtp,
        ),

        const SizedBox(height: 16),

        Center(
          child: TextButton(
            onPressed: authState.isLoading
                ? null
                : () => Navigator.of(context).pop(),
            child: const Text(
              "Change Phone Number",
              style: TextStyle(
                color: Color(0xFF4E73DF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
