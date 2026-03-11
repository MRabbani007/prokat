import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/auth/widgets/auth_switch_link.dart';
import 'package:prokat/features/auth/widgets/register_tabs.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      // MainAxisAlignment.spaceBetween pushes the footer to the bottom
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Padding to help with vertical centering
                        const SizedBox(height: 40),

                        // Main Content Area
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),
                            const Text(
                              "Pick up where you left off",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 32),

                            const RegisterTabs(),

                            SizedBox(
                              height: 350,
                              child: TabBarView(
                                children: [
                                  _buildPhoneLogin(context),
                                  _buildUserLogin(context),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Footer (AuthSwitchLink)
                        // It is pushed to the bottom because of MainAxisAlignment.spaceBetween
                        AuthSwitchLink(
                          message: "New to Prokat? ",
                          actionText: "Create Account",
                          onTap: () => context.go(AppRoutes.register),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLogin(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        _buildLoginField(
          "Phone Number",
          Icons.phone_android_outlined,
          prefixText: "+1 ",
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          "CONTINUE WITH OTP",
          () => context.push('/otp-verification'),
        ),
      ],
    );
  }

  Widget _buildUserLogin(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        _buildLoginField("Username or Email", Icons.alternate_email),
        const SizedBox(height: 16),
        _buildLoginField("Password", Icons.lock_outline, isPassword: true),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildActionButton("SIGN IN", () => context.push(AppRoutes.main)),
      ],
    );
  }

  Widget _buildLoginField(
    String label,
    IconData icon, {
    bool isPassword = false,
    String? prefixText,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        prefixIcon: Icon(icon, size: 20, color: Colors.black87),
        filled: true,
        fillColor:
            Colors.grey[50], // Adjusted from just Colors.grey for better UX
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
