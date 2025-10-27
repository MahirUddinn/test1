import 'package:flutter/material.dart';
import 'presentation/screen/home_screen.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: HomeScreen(),
    );
  }
}
