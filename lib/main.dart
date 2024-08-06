import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/root.dart';

import 'package:weatherapp/ser/loc_provider.dart';
import 'package:weatherapp/ser/weather_ser_pro.dart';


void main(List<String> args) {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> LocationProvider()),
        ChangeNotifierProvider(create: (context)=> WeatherServiceProvider())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
       
       home: Root(),

      ),
    );
  }
}