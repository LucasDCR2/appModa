// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:tonalize/database/produto.dart';

// Exemplo simplificado da tela de seleção de produto
class TelaSelecaoProduto extends StatelessWidget {
  final List<Produto> produtos;

  TelaSelecaoProduto({required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Produto'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return ListTile(
            leading: produto.imagem != null
                ? Image.memory(
                    produto.imagem!, 
                    width: 80,
                    height: 80, 
                    fit: BoxFit.cover, 
                  )
                : Container(), 
            title: Text(produto.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tamanho: ${produto.tamanho}'),
                Text('Cor: ${produto.corNome}'),
                Text('Preço: R\$ ${produto.preco.toStringAsFixed(2)}'), 
              ],
            ),
            onTap: () {
              Navigator.of(context).pop(produto);
            },
          );
        },
      ),
    );
  }
}
