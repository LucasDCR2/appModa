// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'app/home_page.dart';
import 'app/widgets/widget_splash_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseProvider = DatabaseProvider.instance;
  await databaseProvider.initializeDatabase();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tonalize',
      theme: ThemeData(
        primarySwatch: customPurple,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: customPurple,
        ),
      ),
      home: Container(), // Defina uma tela vazia como tela de inicialização padrão
      builder: (context, child) {
        return SplashScreen(
          onSplashComplete: () {
            runApp(
              const MyApp(),
            );
          },
        );
      },
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _trocarTema() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tonalize',
      theme: ThemeData(
        primarySwatch: customPurple,
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: customPurple,
        ),
      ),
      home: HomePage(
        trocarTema: _trocarTema, 
      ),
    );
  }
}
