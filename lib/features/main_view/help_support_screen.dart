import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _sendEmail(String subject) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'supportnabat@gmail.com',
      query: 'subject=$subject',
    );

    await launchUrl(emailUri);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    Widget card(List<Widget> children) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: children),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.helpSupport),
      ),
      body: ListView(
        children: [

          const SizedBox(height: 20),

          card([
            ListTile(
              leading: const Icon(Icons.email, color: Colors.teal),
              title: Text(loc.contactSupport),
              subtitle: const Text("supportnabat@gmail.com"),
              onTap: () => _sendEmail("Support Request - Nabtah"),
            ),
            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.red),
              title: Text(loc.reportBug),
              onTap: () => _sendEmail("Bug Report - Nabtah"),
            ),
            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.orange),
              title: Text(loc.suggestFeature),
              onTap: () => _sendEmail("Feature Suggestion - Nabtah"),
            ),
          ]),

          const SizedBox(height: 20),

          card([
            ListTile(
              leading: const Icon(Icons.question_answer, color: Colors.blue),
              title: Text(loc.faq),
              subtitle: Text(loc.faqDescription),
            ),
          ]),

        ],
      ),
    );
  }
}