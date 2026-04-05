import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nabtah/core/routes/app_routes.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String oobCode;

  ResetPasswordScreen({super.key, required this.oobCode});

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// 🔐 Icon
                  CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.15,
                            backgroundImage: const AssetImage(
                              "assets/images/logo1.png",
                            ),
                          ),

                  const SizedBox(height: 24),

                  Text(
                    lang.resetPasswordTitle,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: lang.newPassword,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: lang.confirmPassword,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔵 Validation Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text("• ${lang.passwordRule1}"),
                        Text("• ${lang.passwordRule2}"),
                        Text("• ${lang.passwordRule3}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        if (passwordController.text !=
                            confirmController.text) return;

                        await FirebaseAuth.instance
                            .confirmPasswordReset(
                          code: oobCode,
                          newPassword:
                              passwordController.text,
                        );

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.resetSuccess,
                          (route) => false,
                        );
                      },
                      child: Text(lang.resetPassword),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}