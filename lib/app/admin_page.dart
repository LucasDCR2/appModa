// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_field

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../database/produto.dart';
import 'dart:typed_data';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController corController = TextEditingController();
  final TextEditingController tamanhoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();

  Uint8List?
      _imagemBytes; // Variável para armazenar os bytes da imagem selecionada.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administração'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Conteúdo da Administração aqui'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _mostrarBottomSheet(context);
              },
              icon: const Icon(Icons.add), 
              label: const Text('Adicionar Produto'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _excluirProdutosDialog(context);
              },
              icon: const Icon(Icons.delete), 
              label: const Text('Excluir Todos os Produtos'),
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

  _mostrarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                const Text('Preencha as informações do produto:'),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: corController,
                  decoration: const InputDecoration(labelText: 'Cor'),
                ),
                TextField(
                  controller: tamanhoController,
                  decoration: const InputDecoration(labelText: 'Tamanho'),
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Fecha o BottomSheet.
                    _adicionarProduto();
                  },
                  child: const Text('Adicionar Imagem'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 Future<void> _excluirProdutosDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Excluir Todos os Produtos?'),
        content: const Text('Esta ação excluirá todos os produtos. Deseja continuar?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red, 
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Não',
              style: TextStyle(color: Colors.white), 
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green, 
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              // Exclui todos os produtos do banco de dados.
              await DatabaseProvider.instance.deleteAllProdutos();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos os produtos foram excluídos.'),
                ),
              );
            },
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.white), 
            ),
          ),
        ],
      );
    },
  );
}


  _adicionarProduto() async {
    final nome = nomeController.text;
    final cor = corController.text;
    final tamanho = tamanhoController.text;

    double preco;

    try {
      preco = double.parse(precoController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um valor de preço válido.'),
        ),
      );
      return; 
    }

    final XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();

      final produto = Produto(
        id: null,
        imagem: bytes,
        nome: nome,
        cor: cor,
        tamanho: tamanho,
        preco: preco,
      );

      final db = await DatabaseProvider.instance.database;
      await db.insert('produtos', produto.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto adicionado ao banco de dados.'),
        ),
      );
    }
  }
}
