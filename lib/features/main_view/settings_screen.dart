import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabtah/core/language_cubit.dart';
import 'package:nabtah/core/notification_service.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/features/main_view/help_support_screen.dart';
import 'package:nabtah/l10n/app_localizations.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) onChangeLanguage;

  const SettingsScreen({super.key, required this.onChangeLanguage});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
  
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  @override
void initState() {
  super.initState();

  if (_notificationsEnabled) {
    NotificationService.startWeeklyReminder();
  }
}

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              color: AppColors.primaryGreen,
              child: Column(
                children: [
                  Text(
                    loc.settings,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    loc.manageApp,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// GENERAL
            _sectionTitle(loc.general),

            _card([
              SwitchListTile(
                value: _notificationsEnabled,
                onChanged: (val) async {
                  setState(() => _notificationsEnabled = val);

                  if (val) {
                    await NotificationService.startWeeklyReminder();
                  } else {
                    await NotificationService.stopReminder();
                  }
                },
                title: Text(loc.notifications),
                secondary: const Icon(
                  Icons.notifications_active,
                  color: AppColors.primaryGreen,
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: AppColors.primaryGreen,
                ),
                title: Text(loc.language),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
            ]),

            /// PRIVACY
            _sectionTitle(loc.privacySecurity),
            _card([
              ListTile(
                leading: const Icon(Icons.shield, color: Colors.red),
                title: Text(loc.privacy),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ]),

            /// SUPPORT
            _sectionTitle(loc.support),
            _card([
              ListTile(
                leading: const Icon(Icons.help, color: Colors.teal),
                title: Text(loc.helpSupport),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),
            ]),

            /// ACCOUNT
            _sectionTitle(loc.account),
            _card([
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(loc.logout),
                onTap: _logout,
              ),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(children: children),
    );
  }

 void _showLanguageDialog() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Language"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("العربية"),
            onTap: () {
              context.read<LanguageCubit>().changeLanguage(const Locale('ar'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("English"),
            onTap: () {
              context.read<LanguageCubit>().changeLanguage(const Locale('en'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }
}
