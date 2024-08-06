// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:weatherapp/routes.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      Navigator.pushNamed(context, Routes.homescreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 160, 201, 229).withOpacity(0.5),
              image: const DecorationImage(
                  image: AssetImage("assets/hh.png"), fit: BoxFit.cover))),
    );
  }
}
