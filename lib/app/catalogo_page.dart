// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../database/produto.dart';
import '../database/database_helper.dart';
import 'widgets/widget_produtos_catalogo.dart';
import 'detalhes.dart'; 

class CatalogoPage extends StatelessWidget {
  const CatalogoPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Produto>>(
        future: DatabaseProvider.instance.getProdutos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os produtos do banco de dados.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado.'),
            );
          } else {
            final produtos = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final produto = produtos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesPage(produto: produto),
                        ),
                      );
                    },
                    child: ProdutoItem(produto: produto),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
