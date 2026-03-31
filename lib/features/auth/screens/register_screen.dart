import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/auth/widgets/auth_switch_link.dart';
import 'package:prokat/features/auth/widgets/register_header.dart';
import 'package:prokat/features/auth/widgets/register_tab_views.dart';
import 'package:prokat/features/auth/widgets/register_tabs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Simple field to store error messages from the backend or validation
  String? errorMessage;

  void setErrorMessage(String? msg) {
    setState(() {
      errorMessage = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF121417);
    const errorColor = Color(0xFFE53935);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor, // Industrial dark background
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
                            const SizedBox(height: 40),
                            const RegisterHeader(),
                            const SizedBox(height: 32),

                            // Simple Error Field Rendering
                            if (errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: errorColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: errorColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: errorColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        errorMessage!,
                                        style: const TextStyle(
                                          color: errorColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            const RegisterTabs(),
                            const SizedBox(height: 24),

                            // Form Views with Error Callback
                            SizedBox(
                              height:
                                  480, // Increased height for the error field + forms
                              child: RegisterTabViews(onError: setErrorMessage),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          // Footer Section
                          child: AuthSwitchLink(
                            message: "Already Registered? ",
                            actionText: "Login",
                            onTap: () => context.go('/login'),
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
