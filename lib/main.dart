import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_for_kids/core/translations/app_translations.dart';
import 'package:english_for_kids/core/routes/app_pages.dart';
import 'package:english_for_kids/core/routes/app_routes.dart';
import 'package:english_for_kids/core/theme/app_theme.dart';

import 'dart:async';
import 'package:exo_shared/exo_shared.dart';
import 'package:english_for_kids/core/bindings/initial_binding.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize services before runApp
      await InitialBinding().initializeServices();

      runApp(const MyApp());
    },
    (error, stack) {
      LoggerUtil.error('Unhandled global error', error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kids English',
      debugShowCheckedModeBanner: false,

      // Translations
      translations: AppTranslations(),
      locale: AppTranslations.defaultLocale, // Vietnamese (VI) as default
      fallbackLocale: AppTranslations.fallbackLocale,

      // Theme
      theme: AppTheme.lightTheme,

      // Routing
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
