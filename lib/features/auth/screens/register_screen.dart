import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/auth/widgets/auth_switch_link.dart';
import 'package:prokat/features/auth/widgets/register_header.dart';
import 'package:prokat/features/auth/widgets/register_tab_views.dart';
import 'package:prokat/features/auth/widgets/register_tabs.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          // LayoutBuilder provides screen constraints
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // physics: ClampingScrollPhysics() prevents "bouncing" that hides the footer
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      // MainAxisAlignment.spaceBetween ensures the footer is pushed to the bottom
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Content Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 40),
                            RegisterHeader(),
                            SizedBox(height: 32),
                            RegisterTabs(),
                            SizedBox(height: 24),
                            // Sized box provides the necessary height for TabBarView
                            SizedBox(
                              height:
                                  450, // Increased height to ensure form fields are visible
                              child: RegisterTabViews(),
                            ),
                          ],
                        ),

                        // Bottom Footer Section
                        AuthSwitchLink(
                          message: "Already Registered? ",
                          actionText: "Login",
                          onTap: () => context.go(AppRoutes.login),
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
