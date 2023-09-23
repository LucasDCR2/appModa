// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:tonalize/main.dart';
import 'package:tonalize/database/produto.dart';
import 'widgets/widget_produtos_relacao.dart';
import 'widgets/widget_detalhes_body.dart';

class DetalhesPage extends StatelessWidget {
  final Produto produto;

  DetalhesPage({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Navegar de volta para a página inicial
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyApp()),
                (route) => false, // Essa função remove todas as outras páginas
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${produto.nome}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),


                DetalhesProdutoWidget(produto: produto),


                const SizedBox(height: 20),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 20,
                  indent: 10,
                  endIndent: 10,
                ),
                const Text(
                  'Produtos Relacionados',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),


                ProdutosComMesmaCorWidget(produtoAtual: produto),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
