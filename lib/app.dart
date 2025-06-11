import 'package:flutter/material.dart';
import 'features/wind/wind_screen.dart';

class SailIQWindApp extends StatelessWidget {
  const SailIQWindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SailIQWind',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WindScreen(),
    );
  }
}