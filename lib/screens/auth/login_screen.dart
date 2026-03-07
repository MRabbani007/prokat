import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                // Fallback if there is no history, e.g., go to a specific route
                context.push(AppRoutes.login);
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Segmented Control Style TabBar
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Phone"),
                    Tab(text: "Username"),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildPhoneLogin(context),
                    _buildUserLogin(context),
                  ],
                ),
              ),

              // Sign Up Link
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New to Prokat? "),
                    GestureDetector(
                      onTap: () => context.pop(), // Goes back to Register
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PHONE LOGIN VIEW
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

  // USERNAME LOGIN VIEW
  Widget _buildUserLogin(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          const SizedBox(height: 16),
          _buildActionButton("SIGN IN", () => context.push(AppRoutes.main)),
        ],
      ),
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
        fillColor: Colors.grey[50],
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
