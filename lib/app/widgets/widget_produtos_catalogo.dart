// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import '../../database/produto.dart';

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
            height: 184,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    produto.nome.length > 14
                        ? '${produto.nome.substring(0, 14)}...'
                        : produto.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ), 
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    Text('${produto.corNome}'),
                    const SizedBox(width: 6.0),
                    Container(
                      width: 16, 
                      height: 16, 
                      decoration: BoxDecoration(
                        color: Color(int.parse('0xFF${produto.cor.substring(1)}')),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('QrCódigo: ${produto.id}',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
