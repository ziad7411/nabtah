import 'package:flutter/material.dart';
import 'package:nabtah/features/main_view/main_layout.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forget_password_screen.dart';
import '../../features/auth/reset_email_sent_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/reset_success_screen.dart';
import '../../splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _route(const SplashScreen());

      case AppRoutes.login:
        return _route(LoginScreen());

      case AppRoutes.register:
        return _route(RegisterScreen());

      case AppRoutes.forgetPassword:
        return _route(ForgetPasswordScreen());

      case AppRoutes.resetEmailSent:
        return _route(const ResetEmailSentScreen());
       
      case AppRoutes.mainView:
        return _route(const MainLayout());

      case AppRoutes.resetPassword:
        final oobCode = settings.arguments;

        if (oobCode == null || oobCode is! String) {
          return _route(
            const Scaffold(body: Center(child: Text("Invalid reset link"))),
          );
        }

        return _route(ResetPasswordScreen(oobCode: oobCode));

      case AppRoutes.resetSuccess:
        return _route(const ResetSuccessScreen());

      default:
        return _route(
          const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }

  static MaterialPageRoute _route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
