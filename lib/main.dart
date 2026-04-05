import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nabtah/core/notification_service.dart';
import 'package:nabtah/core/notification_worker.dart';

import 'package:nabtah/core/routes/app_router.dart';
import 'package:nabtah/core/routes/app_routes.dart';
import 'package:nabtah/core/theme/app_theme.dart';
import 'package:nabtah/features/auth/cubit/auth_cubit.dart';
import 'package:nabtah/core/language_cubit.dart';
import 'package:nabtah/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late final AppLinks _appLinks;
StreamSubscription<Uri>? _sub;
String? pendingResetCode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDeepLinks();
  await NotificationService.init();
  await NotificationService.requestPermission();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(const MyApp());
}

bool modeIsReset(Uri uri) {
  return uri.queryParameters['mode'] == 'resetPassword' &&
      uri.queryParameters['oobCode'] != null;
}

Future<void> initDeepLinks() async {
  _appLinks = AppLinks();

  final Uri? initialUri = await _appLinks.getInitialAppLink();

  if (initialUri != null) {
    handleIncomingLink(initialUri);
  }

  _sub = _appLinks.uriLinkStream.listen((Uri uri) {
    final mode = uri.queryParameters['mode'];
    final oobCode = uri.queryParameters['oobCode'];

    if (mode == 'resetPassword' && oobCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.resetPassword,
          (route) => false,
          arguments: oobCode,
        );
      });
    }
  });
}

void handleIncomingLink(Uri uri) {
  print("FULL URI: $uri");
  print("QUERY: ${uri.queryParameters}");

  final mode = uri.queryParameters['mode'];
  final oobCode = uri.queryParameters['oobCode'];

  if (mode == 'resetPassword' && oobCode != null) {
    pendingResetCode = oobCode;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: AppTheme.lightTheme,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
