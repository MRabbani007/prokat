import 'package:flutter/material.dart';
import 'package:prokat/features/auth/widgets/login_with_phone_form.dart';
import 'package:prokat/features/auth/widgets/login_with_username_form.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/auth/widgets/logo_tile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage;
  bool usePassword = false;

  void setErrorMessage(String? msg) {
    setState(() => errorMessage = msg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  // 1. Added IntrinsicHeight to make Spacer/Expanded work
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to start
                      children: [
                        const SizedBox(height: 40),

                        // Center the branding tile if you want, or leave it start-aligned
                        Center(child: buildMainRedirectTile(context)),

                        const SizedBox(height: 32),

                        Text(
                          "Welcome Back",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          "Pick up where you left off",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        if (errorMessage != null) _buildErrorBox(theme),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: usePassword
                              ? LoginWithUsernameForm(
                                  key: const ValueKey('pw'),
                                  onError: setErrorMessage,
                                )
                              : LoginWithPhoneForm(
                                  key: const ValueKey('phone'),
                                  onError: setErrorMessage,
                                ),
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: TextButton(
                            onPressed: () => setState(() {
                              usePassword = !usePassword;
                              errorMessage = null;
                            }),
                            child: Text(
                              usePassword
                                  ? "Use Phone & OTP instead"
                                  : "Sign in with password",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        /// BOTTOM LINK
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () => context.push('/register'),
                            child: RichText(
                              text: TextSpan(
                                text: "New to Prokat? ",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                children: [
                                  TextSpan(
                                    text: "Create Account",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorBox(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
