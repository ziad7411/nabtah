import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabtah/core/language_cubit.dart';
import 'package:nabtah/core/notification_service.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/features/auth/login_screen.dart';
import 'package:nabtah/features/main_view/main_layout.dart';
import 'package:nabtah/l10n/app_localizations.dart';
import 'cubit/auth_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? selectedRegion;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final lang = AppLocalizations.of(context)!;
    final regions = [
      lang.regionRiyadh,
      lang.regionMakkah,
      lang.regionMadinah,
      lang.regionQassim,
      lang.regionEastern,
      lang.regionAsir,
      lang.regionTabuk,
      lang.regionHail,
      lang.regionNorthern,
      lang.regionJazan,
      lang.regionNajran,
      lang.regionBaha,
      lang.regionJouf,
    ];

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(lang.registerNow),
          actions: [
            IconButton(
              icon: const Icon(Icons.language, color: AppColors.primaryGreen),
              onPressed: () {
                context.read<LanguageCubit>().toggleLanguage();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(blurRadius: 15, color: Colors.black12),
                  ],
                ),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) async{
                     await NotificationService.init();

                    if (state is AuthSuccess) {
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
                            lang.registerTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 30),

                          buildField(
                            hint: lang.fullName,
                            controller: nameController,
                            icon: Icons.person,
                          ),

                          buildField(
                            hint: lang.email,
                            controller: emailController,
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          buildField(
                            hint: lang.phone,
                            controller: phoneController,
                            icon: Icons.phone,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // أرقام فقط
                              LengthLimitingTextInputFormatter(
                                10,
                              ), // 10 أرقام فقط
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              }

                              if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
                                return "Enter valid Saudi phone number";
                              }

                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: DropdownButtonFormField<String>(
                              value: selectedRegion,
                              items: regions
                                  .map(
                                    (region) => DropdownMenuItem(
                                      value: region,
                                      child: Text(region),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                selectedRegion = value;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return lang.regionRequired;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: lang.selectRegion,
                                prefixIcon: const Icon(Icons.location_on),
                              ),
                            ),
                          ),

                          buildField(
                            hint: lang.password,
                            controller: passwordController,
                            icon: Icons.lock,
                            isPassword: true,
                          ),

                          buildField(
                            hint: lang.confirmPassword,
                            controller: confirmPasswordController,
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 20),

                          state is AuthLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              lang.passwordNotMatch,
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      context.read<AuthCubit>().register(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        phone: phoneController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        region: selectedRegion!,
                                      );
                                    },
                                    child: Text(lang.createAccount),
                                  ),
                                ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lang.alreadyHaveAccount),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(lang.loginTitle),
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
    );
  }

  Widget buildField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
