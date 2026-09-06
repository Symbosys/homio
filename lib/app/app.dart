import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

export 'router/app_router.dart';

/// Root application widget for Homio SaaS Platform.
/// Automatically renders Light or Dark mode based on the user's system appearance.
class HomioApp extends StatelessWidget {
  const HomioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Homio — Unified Business OS & CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
