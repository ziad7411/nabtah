import 'package:flutter/material.dart';
import 'package:nabtah/l10n/app_localizations.dart';

import 'home_screen.dart';
import 'plants_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Locale _locale = const Locale('ar');

void _changeLanguage(Locale locale) {
  setState(() {
    _locale = locale;
  });
}
  int currentIndex = 0;

  List<Widget> get screens => [
    const HomeScreen(),
    const PlantsPage(),
    const ProfileScreen(),
    SettingsScreen(onChangeLanguage: _changeLanguage,),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
             activeIcon: const Icon(Icons.home),
            label: lang.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.eco_outlined),
            activeIcon: const Icon(Icons.eco),
            label: lang.plants,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            activeIcon: const Icon(Icons.person),
            label: lang.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
             activeIcon: const Icon(Icons.settings),
            label: lang.settings,
          ),
        ],
      ),
    );
  }
}
