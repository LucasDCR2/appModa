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
    return SizedBox(
      width: double.infinity,
      height: 250,
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
                                color: Color(int.parse(
                                    '0xFF${produto.cor.substring(1)}')),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('QrCódigo: ${produto.id}',
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
