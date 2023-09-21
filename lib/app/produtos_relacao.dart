// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:teste1/database/produto.dart';
import 'package:teste1/database/database_helper.dart';

class ProdutosComMesmaCorWidget extends StatelessWidget {
  final String cor;
  final String corNome;
  final Produto produtoAtual;

  ProdutosComMesmaCorWidget({
    required this.cor,
    required this.corNome,
    required this.produtoAtual,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: FutureBuilder<List<Produto>>(
        future: DatabaseProvider.instance.getProdutosPorCor(cor, corNome),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            // Filtrar produtos com a mesma cor, excluindo o produto atual
            final produtosDaMesmaCor = snapshot.data!
                .where((produto) => produto.id != produtoAtual.id)
                .toList();
            if (produtosDaMesmaCor.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum produto encontrado.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: produtosDaMesmaCor.length,
              itemBuilder: (context, index) {
                final produto = produtosDaMesmaCor[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 150,
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
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        produto.nome,
                        style: const TextStyle(fontSize: 16),
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
                      Text(
                        'R\$ ${produto.preco.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
