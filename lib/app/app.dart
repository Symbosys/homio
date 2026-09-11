import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import 'router/app_router.dart';

export 'router/app_router.dart';

/// Root application widget for Homio SaaS Platform.
/// Automatically renders Light or Dark mode with support for dynamic theme toggling.
class HomioApp extends StatelessWidget {
  const HomioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Homio — Unified Business OS & CRM',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeController.instance.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
