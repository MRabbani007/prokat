import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/otp_field.dart';

class OtpVerificationForm extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationForm({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationForm> createState() =>
      _OtpVerificationFormState();
}

class _OtpVerificationFormState extends ConsumerState<OtpVerificationForm> {
  final otpController = TextEditingController();

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid OTP")),
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .verifyOtp(widget.phone, otp);

    if (success !=null && mounted) {
      context.go(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Column(
      children: [
        const SizedBox(height: 40),

        Text(
          "Enter the OTP sent to ${widget.phone}",
          style: const TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 16),

        OtpField(controller: otpController),

        const SizedBox(height: 24),

        AuthButton(
          loading: authState.isLoading,
          text: "VERIFY OTP",
          loadingText: "Verifying...",
          onPressed: verifyOtp,
        ),
      ],
    );
  }
}