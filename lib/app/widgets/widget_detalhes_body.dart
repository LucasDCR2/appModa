// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:tonalize/database/produto.dart';

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
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Cor: ${produto.corNome}',
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
