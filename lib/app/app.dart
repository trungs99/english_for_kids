import 'package:english_for_kids/app/routes/m_routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English for Kids',
      debugShowCheckedModeBanner: false,
      initialRoute: MRoutes.home,
      onGenerateRoute: MRoutes.onGenerateRoute,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
