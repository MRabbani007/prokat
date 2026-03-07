import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

import 'username_register_form.dart';
import 'phone_register_form.dart';

class RegisterTabs extends StatelessWidget {
  const RegisterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TabBar(
              indicator: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(text: "Phone"),
                Tab(text: "UserName"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: TabBarView(
              children: [PhoneRegisterForm(), UserNameRegisterForm()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.login),
                  child: const Text(
                    "Log In",
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
    );
  }
}
