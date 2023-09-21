import 'package:flutter/material.dart';
import '../database/produto.dart';

class ProdutoItem extends StatelessWidget {
  final Produto produto;

  const ProdutoItem({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.memory(
            produto.imagem!,
            width: double.infinity,
            height: 200, 
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Tamanho: ${produto.tamanho}'),
                Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
