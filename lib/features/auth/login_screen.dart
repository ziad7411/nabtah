import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabtah/core/notification_service.dart';
import 'package:nabtah/core/routes/app_routes.dart';
import 'package:nabtah/features/auth/register_screen.dart';
import 'package:nabtah/features/main_view/main_layout.dart';
import 'package:nabtah/l10n/app_localizations.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final lang = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: AppColors.background),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black12,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) async{
                      if (state is AuthSuccess) {
                         await NotificationService.init();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MainLayout()),
                          (route) => false,
                        );
                      }

                      if (state is AuthError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            /// LOGO
                            CircleAvatar(
                              radius: size.width * 0.15,
                              backgroundImage: const AssetImage(
                                "assets/images/logo1.png",
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// TITLE
                            Text(
                              lang.loginTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 30),

                            /// EMAIL
                            buildField(
                              hint: lang.emailHint,
                              controller: emailController,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            /// PASSWORD
                            buildField(
                              hint: lang.passwordHint,
                              controller: passwordController,
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),

                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.forgetPassword,
                                  );
                                },
                                child: Text(
                                  lang.forgotPassword,
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// BUTTON
                            state is AuthLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        context.read<AuthCubit>().login(
                                          email: emailController.text.trim(),
                                          password: passwordController.text
                                              .trim(),
                                        );
                                      },
                                      child: Text(
                                        lang.loginButton,
                                        style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.05,
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 20),

                            /// REGISTER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lang.noAccount),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    lang.registerNow,
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon)),
      ),
    );
  }
}
