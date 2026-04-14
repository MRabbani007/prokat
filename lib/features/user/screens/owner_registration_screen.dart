import 'package:flutter/material.dart';

enum OwnerVerificationStatus { incomplete, pending, approved, rejected }

class OwnerRegistrationScreen extends StatelessWidget {
  final OwnerVerificationStatus? status;

  const OwnerRegistrationScreen({
    super.key,
    this.status = OwnerVerificationStatus.incomplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Owner Verification")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusCard(theme),
          const SizedBox(height: 16),

          _buildChecklist(theme),
          const SizedBox(height: 16),

          _sectionTitle("Documents", theme),
          _card([
            _documentTile("ID / Passport", true, () {}),
            _documentTile("Proof of Address", false, () {}),
            _documentTile("Business License (optional)", false, () {}),
          ]),

          const SizedBox(height: 16),

          _sectionTitle("Legal Information", theme),
          _card([
            _tile("Full Name", "Mohamad Rabbani", () {}),
            _tile("Address", "Atyrau, Kazakhstan", () {}),
            _tile("Phone Number", "+7 XXX XXX", () {}),
          ]),

          const SizedBox(height: 24),

          _buildCTA(context),
        ],
      ),
    );
  }

  /// 🔥 STATUS CARD (core UX)
  Widget _buildStatusCard(ThemeData theme) {
    String title;
    String subtitle;
    Color color;
    IconData icon;

    switch (status) {
      case OwnerVerificationStatus.incomplete:
        title = "Complete your registration";
        subtitle = "Submit required documents to start listing equipment.";
        color = Colors.orange;
        icon = Icons.pending_actions;
        break;

      case OwnerVerificationStatus.pending:
        title = "Verification in progress";
        subtitle = "We are reviewing your documents.";
        color = Colors.blue;
        icon = Icons.hourglass_top;
        break;

      case OwnerVerificationStatus.approved:
        title = "You're verified 🎉";
        subtitle = "You can now list and rent out equipment.";
        color = Colors.green;
        icon = Icons.verified;
        break;

      case OwnerVerificationStatus.rejected:
        title = "Verification failed";
        subtitle = "Please update your documents and try again.";
        color = Colors.red;
        icon = Icons.error_outline;
        break;

      default:
        title = "Complete your registration";
        subtitle = "Submit required documents to start listing equipment.";
        color = Colors.orange;
        icon = Icons.pending_actions;
    }

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  /// 📋 CHECKLIST
  Widget _buildChecklist(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Your Progress", theme),
        const SizedBox(height: 8),

        _checkItem("Upload ID", true),
        _checkItem("Add address", true),
        _checkItem("Upload proof of address", false),
      ],
    );
  }

  Widget _checkItem(String text, bool done) {
    return ListTile(
      leading: Icon(
        done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: done ? Colors.green : null,
      ),
      title: Text(text),
    );
  }

  /// 📄 DOCUMENT TILE
  Widget _documentTile(String title, bool uploaded, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(uploaded ? "Uploaded" : "Required"),
      trailing: Icon(
        uploaded ? Icons.check_circle : Icons.upload_file,
        color: uploaded ? Colors.green : null,
      ),
      onTap: onTap,
    );
  }

  /// 🔧 GENERAL TILE
  Widget _tile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(title, style: theme.textTheme.titleMedium);
  }

  Widget _card(List<Widget> children) {
    return Card(child: Column(children: children));
  }

  /// 🚀 CTA BUTTON (dynamic)
  Widget _buildCTA(BuildContext context) {
    String text;

    switch (status) {
      case OwnerVerificationStatus.incomplete:
        text = "Submit for Verification";
        break;
      case OwnerVerificationStatus.pending:
        text = "Under Review";
        break;
      case OwnerVerificationStatus.approved:
        text = "View Listings";
        break;
      case OwnerVerificationStatus.rejected:
        text = "Resubmit Documents";
        break;
      default:
        text = "Submit for Verification";
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: status == OwnerVerificationStatus.pending ? null : () {},
        child: Text(text),
      ),
    );
  }
}
