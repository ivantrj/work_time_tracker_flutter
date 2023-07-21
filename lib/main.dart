import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_time_tracker/views/settings_view.dart';
import 'package:work_time_tracker/views/setup_view.dart';
import 'package:work_time_tracker/views/work_view.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => SetupView()),
          GoRoute(path: '/work', builder: (context, state) => WorkView()),
          GoRoute(path: '/settings', builder: (context, state) => SettingsView()),
        ],
      ),
    );
  }
}
