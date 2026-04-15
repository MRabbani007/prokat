import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import 'otp_verification_form.dart';

class LoginWithPhoneForm extends ConsumerStatefulWidget {
  final Function(String?) onError;

  const LoginWithPhoneForm({super.key, required this.onError});

  @override
  ConsumerState<LoginWithPhoneForm> createState() => _LoginWithPhoneFormState();
}

class _LoginWithPhoneFormState extends ConsumerState<LoginWithPhoneForm> {
  final phoneController = TextEditingController(text: "+7");

  bool showOtp = false;
  String phone = "";

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool isValidKazakhstanPhone(String phone) {
    // Matches +7 followed by 10 digits
    final regex = RegExp(r'^\+7\d{10}$');
    return regex.hasMatch(phone);
  }

  Future<void> requestOtp() async {
    final value = phoneController.text.trim();

    // 1. Frontend Validation: No submit if empty or invalid
    if (value == "+7" || value.isEmpty) {
      widget.onError("Please enter your phone number");
      return;
    }

    if (!isValidKazakhstanPhone(value)) {
      widget.onError("Enter a valid Kazakhstan phone (+7 XXX XXX XXXX)");
      return;
    }

    // Clear previous errors
    widget.onError(null);

    try {
      final success = await ref.read(authProvider.notifier).requestOtp(value);

      if (!success) {
        widget.onError("Failed to send OTP. Please try again.");
      }

      await ref.read(userProfileProvider.notifier).getUserProfile();
      // setState(() {
      //     phone = value;
      //     showOtp = true;
      //   });
    } catch (e) {
      // Handle Backend/Connection Errors
      widget.onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final hasOtpSession =
        authState.otpPhone != null && authState.otpRequestedAt != null;

    if (hasOtpSession) {
      // Passing onError to the next form as well
      return OtpVerificationForm(
        phone: authState.otpPhone!,
        onError: widget.onError,
      );
    }

    return Column(
      children: [
        const SizedBox(height: 20),

        AuthTextField(
          label: "Phone Number",
          icon: Icons.phone_android_outlined,
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 24),

        AuthButton(
          loading: authState.isLoading,
          text: "Send Otp",
          loadingText: "Sending...",
          onPressed: requestOtp,
        ),
      ],
    );
  }
}
