// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../app/catalogo_page.dart';
import '../app/admin_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback trocarTema; 
  const HomePage({required this.trocarTema, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LookApp'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6), 
            onPressed: trocarTema,
          ),
        ],
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CatalogoPage()),
                );
              },
              icon: const Icon(Icons.shopping_cart), 
              label: const Text('Ir para o Catálogo'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
                ),
                padding: const EdgeInsets.all(16), 
              ),
            ),
            const SizedBox(height: 20), 
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                );
              },
              icon: const Icon(Icons.settings), 
              label: const Text('Ir para a Administração'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
                ),
                padding: const EdgeInsets.all(16), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
