import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_1/presentation/screens/splash-screen.dart';
import 'data/repositories/api_repository.dart';
import 'logic/auth_bloc/auth_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiRepository(),

      child: BlocProvider(
        create: (context) =>
            AuthBloc(repository: context.read<ApiRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Customer Invoice App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[50],
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black87),
            ),
          ),

          home: const SplashScreen(),
        ),
      ),
    );
  }
}
