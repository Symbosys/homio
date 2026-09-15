import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app/app.dart';
import 'core/auth/auth_state_notifier.dart';

export 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Initialize global TanStack Query configuration
  CachedQuery.instance.config(
    config: const GlobalQueryConfig(
      staleDuration: Duration(minutes: 5),
      cacheDuration: Duration(hours: 1),
    ),
  );

  // Initialize persistent authentication session
  await AuthStateNotifier.instance.initialize();

  runApp(const HomioApp());
}
