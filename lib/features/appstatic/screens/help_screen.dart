import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Search help...",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),

                const SizedBox(height: 24),

                _buildSectionTitle("Frequently Asked Questions", theme),
                const SizedBox(height: 12),
                _buildFAQ(),

                const SizedBox(height: 24),

                _buildSectionTitle("Need more help?", theme),
                const SizedBox(height: 12),
                _buildHelpOptions(context),
              ],
            ),
          ),

          /// 🔥 Contact Support CTA
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _openSupport(context);
                  },
                  child: const Text("Contact Support"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("How can we help?", style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          "Find answers to common questions or reach out to our support team.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(title, style: theme.textTheme.titleMedium);
  }

  Widget _buildFAQ() {
    final faqs = [
      {
        "q": "How do I rent equipment?",
        "a":
            "Browse available equipment, select your dates, and send a booking request to the owner.",
      },
      {
        "q": "How do I list my equipment?",
        "a":
            "Go to your profile and tap 'Add Equipment'. Fill in details, pricing, and location.",
      },
      {
        "q": "How do payments work?",
        "a":
            "Payments are handled securely through the platform. You’ll see the total before confirming.",
      },
      {
        "q": "Can I cancel a booking?",
        "a":
            "Yes, depending on the owner's cancellation policy shown on the equipment page.",
      },
      {
        "q": "What if equipment is damaged?",
        "a":
            "Report the issue through the app immediately. Our support team will assist you.",
      },
    ];

    return Column(
      children: faqs.map((faq) {
        return ExpansionTile(
          title: Text(faq["q"]!),
          children: [
            Padding(padding: const EdgeInsets.all(12), child: Text(faq["a"]!)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHelpOptions(BuildContext context) {
    return Column(
      children: [
        _helpTile(
          icon: Icons.book_outlined,
          title: "Using Prokat",
          subtitle: "Learn how the platform works",
          onTap: () {},
        ),
        _helpTile(
          icon: Icons.payment_outlined,
          title: "Payments & Pricing",
          subtitle: "Fees, payouts, and billing",
          onTap: () {},
        ),
        _helpTile(
          icon: Icons.security_outlined,
          title: "Safety & Trust",
          subtitle: "Guidelines and policies",
          onTap: () {},
        ),
        _helpTile(
          icon: Icons.person_outline,
          title: "Account Help",
          subtitle: "Login, profile, and settings",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _helpTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _openSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Contact Support",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text("Email Support"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text("Live Chat"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text("Call Us"),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
