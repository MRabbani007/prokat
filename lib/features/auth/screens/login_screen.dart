import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/auth/widgets/auth_switch_link.dart';
import 'package:prokat/features/auth/widgets/login_with_phone_form.dart';
import 'package:prokat/features/auth/widgets/login_with_username_form.dart';
import 'package:prokat/features/auth/widgets/register_tabs.dart';

const bgColor = Color(0xFF121417);
const ghostGray = Color(0x4DFFFFFF); // White @ 30%
const accentColor = Color(0xFF4E73DF);
const errorColor = Color(0xFFE53935);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage; // Simple field to store backend/validation errors

  void setErrorMessage(String? msg) {
    setState(() {
      errorMessage = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),
                            const Text(
                              "Pick up where you left off",
                              style: TextStyle(
                                color: ghostGray,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Error Field Rendering
                            if (errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: errorColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: errorColor.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: errorColor, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        errorMessage!,
                                        style: const TextStyle(color: errorColor, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            const RegisterTabs(), // Ensure this widget uses accentColor for indicators
                            SizedBox(
                              height: 400, // Increased slightly for error spacing
                              child: TabBarView(
                                children: [
                                  LoginWithPhoneForm(onError: setErrorMessage),
                                  LoginWithUsernameForm(onError: setErrorMessage),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AuthSwitchLink(
                            message: "New to Prokat? ",
                            actionText: "Create Account",
                            // Style this text with ghostGray and accentColor
                            onTap: () => context.go('/register'), 
                          ),
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
}