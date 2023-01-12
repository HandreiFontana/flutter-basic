import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:basic/shared/routes/app_routes.dart';
import 'package:basic/shared/themes/app_theme.dart';
import 'package:basic/presentation/providers/app_providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'basic',
        theme: AppThemes.mainTheme,
        routes: appRoutes,
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
