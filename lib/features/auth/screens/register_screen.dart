import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/auth/widgets/register_with_phone_form.dart';
import 'package:prokat/features/auth/widgets/register_with_username_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage;
  bool useEmail = false;

  void setErrorMessage(String? msg) {
    setState(() => errorMessage = msg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = colorScheme.surface;
    final accentColor = colorScheme.primary;
    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.6);
    final errorColor = colorScheme.error;

    return Scaffold(
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

                      /// TOP CONTENT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Account",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Join the Prokat community today",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ghostGray,
                            ),
                          ),
                          const SizedBox(height: 32),

                          if (errorMessage != null)
                            _buildErrorBox(context, errorColor),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: useEmail
                                ? RegisterWithUsernameForm(
                                    key: const ValueKey('email'),
                                    onError: setErrorMessage,
                                  )
                                : RegisterWithPhoneForm(
                                    key: const ValueKey('phone'),
                                    onError: setErrorMessage,
                                  ),
                          ),

                          const SizedBox(height: 16),

                          /// TOGGLE METHOD
                          Center(
                            child: TextButton(
                              onPressed: () => setState(() {
                                useEmail = !useEmail;
                                errorMessage = null;
                              }),
                              child: Text(
                                useEmail
                                    ? "Register with Phone instead"
                                    : "Use Email & Password",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// BOTTOM LINK
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildLoginLink(context, ghostGray, accentColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorBox(BuildContext context, Color errorColor) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: errorColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: errorColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink(
    BuildContext context,
    Color ghostGray,
    Color accentColor,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.go('/login'),
      child: RichText(
        text: TextSpan(
          text: "Already Registered? ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: ghostGray,
          ),
          children: [
            TextSpan(
              text: "Login",
              style: theme.textTheme.bodySmall?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}