import 'package:flutter/material.dart';
import 'package:test1/data/database_helper.dart';
import 'package:test1/presentation/bloc/task_cubit/task_cubit.dart';
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
      home: MultiBlocProvider(providers: [
        BlocProvider(create: (context) => TodoCubit(AppDatabase()),),
        BlocProvider(create: (context) => TaskCubit(AppDatabase()),)
      ], child: HomeScreen()),
      );
  }
}
