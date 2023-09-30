// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'catalogo_page.dart';
import 'admin_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback trocarTema;
  const HomePage({required this.trocarTema, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum UserType { client, admin }

class _HomePageState extends State<HomePage> {
  UserType selectedUserType = UserType.admin;
  bool isAdminVisible = false;
  bool isToggleButtonVisible = true; // Novo estado para controlar a visibilidade do botão de alternância

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleUserType() {
    setState(() {
      selectedUserType = selectedUserType == UserType.client
          ? UserType.admin
          : UserType.client;
      isAdminVisible = selectedUserType == UserType.admin;
      isToggleButtonVisible = selectedUserType == UserType.client; // Ocultar o botão após alternar para admin
    });
  }

  Future<void> _showAdminLoginDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login de Administrador'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Entrar'),
              onPressed: () {
                // Aqui, você deve implementar sua lógica real de autenticação de administrador
                // Substitua a lógica fictícia abaixo pelo seu próprio sistema de autenticação.
                String name = nameController.text;
                String password = passwordController.text;
                bool isAdminValid = (name == 'adm' && password == 'adm');

                if (isAdminValid) {
                  Navigator.of(context).pop(true); // Indica login bem-sucedido
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nome ou senha de administrador inválidos.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        selectedUserType = UserType.admin;
        isAdminVisible = true;
        isToggleButtonVisible = false; // Ocultar o botão após o login bem-sucedido
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/logo_tonalize.png',
            width: 130, height: 100),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.trocarTema,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (isToggleButtonVisible) 
              ElevatedButton(
                onPressed: selectedUserType == UserType.client
                    ? toggleUserType
                    : _showAdminLoginDialog,
                child: Text(
                  selectedUserType == UserType.client
                      ? 'Entrar como Cliente'
                      : 'Entrar como Admin',
                ),
              ),
            SizedBox(height: 150),
            if (isAdminVisible)
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
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
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
          ],
        ),
      ),
    );
  }
}

