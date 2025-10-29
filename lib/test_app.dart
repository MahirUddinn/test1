import 'package:flutter/material.dart';
import 'package:test1/data/database_helper.dart';
import 'package:test1/presentation/bloc/todo_cubit/todo_cubit.dart';
import 'presentation/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF81C784))
      ),
      home: BlocProvider(
        create: (context) => TodoCubit(AppDatabase()),
        child: HomeScreen(),
      ),
    );
  }
}
