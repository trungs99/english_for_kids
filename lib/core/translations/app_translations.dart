import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'en.dart';
import 'vi.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'vi_VN': vi};

  static const Locale defaultLocale = Locale('vi', 'VN');
  static const Locale fallbackLocale = Locale('en', 'US');

  static final List<Locale> supportedLocales = [defaultLocale, fallbackLocale];
}
