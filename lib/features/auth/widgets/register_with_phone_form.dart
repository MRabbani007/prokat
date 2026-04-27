import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/auth/widgets/auth_button.dart';
import 'package:prokat/features/auth/widgets/auth_text_field.dart';
import 'package:prokat/features/auth/widgets/otp_verification_form.dart';

class RegisterWithPhoneForm extends ConsumerStatefulWidget {
  final Function(String?) onError;

  const RegisterWithPhoneForm({super.key, required this.onError});

  @override
  ConsumerState<RegisterWithPhoneForm> createState() =>
      _RegisterWithPhoneFormState();
}

class _RegisterWithPhoneFormState extends ConsumerState<RegisterWithPhoneForm> {
  final phoneController = TextEditingController(text: "+7");
  bool showOtp = false;
  String phone = "";

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool isValidKazakhstanPhone(String phone) {
    return RegExp(r'^\+7\d{10}$').hasMatch(phone);
  }

  Future<void> requestOtp() async {
    final value = phoneController.text.trim();

    // 1. Frontend Validation
    if (value == "+7" || value.isEmpty) {
      widget.onError("Please enter your phone number");
      return;
    }

    if (!isValidKazakhstanPhone(value)) {
      widget.onError("Enter a valid Kazakhstan phone (+7XXXXXXXXXX)");
      return;
    }

    widget.onError(null); // Clear previous errors

    try {
      final success = await ref.read(authProvider.notifier).requestOtp(value);

      if (success) {
        setState(() {
          phone = value;
          showOtp = true;
        });
      } else {
        widget.onError("Registration failed. Try again.");
      }
    } catch (e) {
      widget.onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // If OTP is sent, switch to the Verification form
    if (showOtp) {
      return OtpVerificationForm(phone: phone, onError: widget.onError);
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
          text: "SEND CODE",
          loadingText: "SENDING...",
          onPressed: requestOtp,
        ),
      ],
    );
  }
}
