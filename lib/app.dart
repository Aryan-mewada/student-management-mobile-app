import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management System',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const RegisterScreen(),
    );
  }
}