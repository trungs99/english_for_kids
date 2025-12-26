import 'package:english_for_kids/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';

class MRoutes {
  static const home = '/home';

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return HomePage.getPageRoute(routeSettings);
      default:
        return null;
    }
  }
}
