import 'package:cubit_shantika/config/service_locator.dart';
import 'package:cubit_shantika/feature/navigation/navigation_cubit.dart';
import 'package:cubit_shantika/feature/navigation/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/navigation/navigation_cubit.dart' hide NavigationCubit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Service Locator
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Testing cubit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) => NavigationCubit(),
        child: NavigationPage(),
      ),
    );
  }
}
