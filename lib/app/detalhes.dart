// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:teste1/database/produto.dart';

class DetalhesPage extends StatelessWidget {
  final Produto produto;

  DetalhesPage({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
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
                  color: Colors.grey, // Cor do risco cinza
                  thickness: 2, // Espessura do risco
                  height: 20, // Espaçamento acima do risco
                  indent: 10, // Recuo à esquerda do risco
                  endIndent: 10, // Recuo à direita do risco
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class DetalhesProdutoWidget extends StatelessWidget {
  final Produto produto;

  DetalhesProdutoWidget({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Exibir a imagem do produto se necessário
        if (produto.imagem != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                produto.imagem!,
                height: 400,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
        // Exibir as informações do produto aqui
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20, // Largura da caixa de cor
              height: 20, // Altura da caixa de cor
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${produto.cor.substring(1)}')),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 8), // Espaçamento entre a caixa de cor e o texto
            Text(
              'Cor: ${produto.cor}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Tamanho: ${produto.tamanho}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'R\$ ${produto.preco.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
