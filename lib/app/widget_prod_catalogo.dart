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
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Text(
                      'Cor: ${produto.corNome}',
                    ),
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
                Text('R\$ ${produto.preco.toStringAsFixed(2)}',
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
