import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'components/login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StreamInstagramApp());
}

/// {@template app}
/// Main entry point to the application.
/// {@endtemplate}
class StreamInstagramApp extends StatelessWidget {
  /// {@macro app}
  const StreamInstagramApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedState(),
      child: MaterialApp(
        title: 'Stream Instagram',
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
