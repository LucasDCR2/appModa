// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:tonalize/constants.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onSplashComplete;
  
  SplashScreen({required this.onSplashComplete});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      onSplashComplete(); // Chama a função onSplashComplete para navegar para a MyApp
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/Logo_Tonalize_Simbolo.png', // Caminho para a imagem da logo
          width: 200, // Largura desejada da imagem
          height: 200, // Altura desejada da imagem
        ),
      ),
    );
  }
}
