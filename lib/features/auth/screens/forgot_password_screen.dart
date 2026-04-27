import 'package:flutter/material.dart';
import 'package:prokat/features/auth/widgets/auth_button.dart';
import 'package:prokat/features/auth/widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isSent = false;
  String? errorMessage;
  final TextEditingController _emailController = TextEditingController();

  void setErrorMessage(String? msg) => setState(() => errorMessage = msg);

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF121417);
    const ghostGray = Color(0x4DFFFFFF);
    const accentColor = Color(0xFF4E73DF);
    const errorColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_reset_rounded, size: 64, color: accentColor),
            const SizedBox(height: 32),
            Text(
              _isSent ? "Check your email" : "Reset Password",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isSent
                  ? "We've sent a recovery link to ${_emailController.text}"
                  : "Enter your registered email below to receive a password reset link.",
              style: const TextStyle(color: ghostGray, fontSize: 16),
            ),

            // Error Field Rendering
            if (errorMessage != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: errorColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: errorColor, fontSize: 14),
                ),
              ),
            ],

            const SizedBox(height: 48),

            if (!_isSent) ...[
              AuthTextField(
                label: "Email Address",
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              AuthButton(
                loading: false, // Integrate with your state if needed
                text: "SEND RECOVERY LINK",
                loadingText: "SENDING...",
                onPressed: () {
                  if (_emailController.text.isEmpty) {
                    setErrorMessage("Please enter your email address");
                    return;
                  }
                  setErrorMessage(null);
                  setState(() => _isSent = true);
                },
              ),
            ] else ...[
              AuthButton(
                loading: false,
                text: "BACK TO LOGIN",
                loadingText: "LOADING...",
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Logic for resending
                    setErrorMessage(null);
                  },
                  child: const Text(
                    "Resend Link",
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
