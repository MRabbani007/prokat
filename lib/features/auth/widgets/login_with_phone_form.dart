import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import 'otp_verification_form.dart';

class LoginWithPhoneForm extends ConsumerStatefulWidget {
  const LoginWithPhoneForm({super.key});

  @override
  ConsumerState<LoginWithPhoneForm> createState() => _LoginWithPhoneFormState();
}

class _LoginWithPhoneFormState extends ConsumerState<LoginWithPhoneForm> {
  final phoneController = TextEditingController();

  bool showOtp = false;
  String phone = "";

  bool isValidKazakhstanPhone(String phone) {
    final regex = RegExp(r'^\+7\d{10}$');
    return regex.hasMatch(phone);
  }

  Future<void> requestOtp() async {
    final value = phoneController.text.trim();

    if (!isValidKazakhstanPhone(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid Kazakhstan phone number")),
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .requestOtp(value);

    if (success) {
      setState(() {
        phone = value;
        showOtp = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (showOtp) {
      return OtpVerificationForm(phone: phone);
    }

    return Column(
      children: [
        const SizedBox(height: 40),

        AuthTextField(
          label: "Phone Number",
          icon: Icons.phone_android_outlined,
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 24),

        AuthButton(
          loading: authState.isLoading,
          text: "CONTINUE WITH OTP",
          loadingText: "Sending...",
          onPressed: requestOtp,
        ),
      ],
    );
  }
}