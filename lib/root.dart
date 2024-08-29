import 'package:flutter/material.dart';
import 'package:weatherapp/routes.dart';
import 'package:weatherapp/screen/home.dart';
import 'package:weatherapp/splashscreen.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashscreen, routes: {
      Routes.splashscreen: (context) =>  Splashscreen(),
      Routes.homescreen :(context) => const HomePage()
    });
  }
}
