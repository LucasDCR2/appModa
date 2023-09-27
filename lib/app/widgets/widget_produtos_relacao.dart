// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tonalize/app/detalhes.dart';
import 'package:tonalize/database/produto.dart';
import 'package:tonalize/database/database_helper.dart';

class ProdutosComMesmaCorWidget extends StatefulWidget {
  final Produto produtoAtual;

  ProdutosComMesmaCorWidget({
    required this.produtoAtual,
  });

  @override
  _ProdutosComMesmaCorWidgetState createState() =>
      _ProdutosComMesmaCorWidgetState();
}

class _ProdutosComMesmaCorWidgetState extends State<ProdutosComMesmaCorWidget> {
  late Future<List<Produto>> produtosFiltrados;

  @override
  void initState() {
    super.initState();
    // Carregue a lista de cores combinantes no initState
    produtosFiltrados = _carregarProdutosFiltrados();
  }

  Future<List<Produto>> _carregarProdutosFiltrados() async {
    final coresCombinantes = await DatabaseProvider.instance.getCoresCombinantes(widget.produtoAtual.corNome, widget.produtoAtual.cor);

    final List<Produto> produtosFiltrados = [];

    for (final corCombinante in coresCombinantes) {
      final produtos =
          await DatabaseProvider.instance.getProdutosPorCores([corCombinante]);
      produtosFiltrados.addAll(produtos);
    }

    return produtosFiltrados;
  }

 @override
Widget build(BuildContext context) {
  final screenHeight = 250.0; // Defina a altura da tela desejada em unidades lógicas

  return SizedBox(
    width: double.infinity,
    height: screenHeight,
    child: FutureBuilder<List<Produto>>(
      future: produtosFiltrados,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          final produtosFiltrados = snapshot.data ?? [];
          if (produtosFiltrados.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum produto encontrado.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: produtosFiltrados.length,
            itemBuilder: (context, index) {
              final produto = produtosFiltrados[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesPage(produto: produto),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenHeight * 0.48, // Defina a largura como 48% da altura da tela
                        height: screenHeight * 0.6, // Defina a altura como 60% da altura da tela
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
                            height: screenHeight * 0.4, // Defina a altura como 40% da altura da tela
                            width: screenHeight * 0.4, // Defina a largura como 40% da altura da tela
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                            height: screenHeight *
                                0.04), // Espaçamento de 4% da altura da tela
                        Text(
                          produto.nome.length <= 12
                              ? produto.nome
                              : '${produto.nome.substring(0, 12)}...',
                          style: const TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.048), // Espaçamento de 4.8% da altura da tela
                        Row(
                        children: [
                          Text(
                            'Cor: ${produto.corNome}', 
                            style: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: screenHeight * 0.02), // Espaçamento de 1.2% da altura da tela
                          Container(
                            width: screenHeight * 0.065, // Largura de 3.2% da altura da tela
                            height: screenHeight * 0.065, // Altura de 3.2% da altura da tela
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  '0xFF${produto.cor.substring(1)}')),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.004), // Espaçamento de 0.4% da altura da tela
                      Text(
                        'QrCódigo: ${produto.id}',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
