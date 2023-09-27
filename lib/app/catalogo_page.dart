// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../database/produto.dart';
import '../database/database_helper.dart';
import 'widgets/widget_produtos_catalogo.dart';
import 'detalhes.dart';
import 'package:tonalize/app/widgets/widget_combinacoes_cores.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({Key? key}) : super(key: key);

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final TextEditingController qrCodeController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String searchTerm = ''; // Termo de pesquisa


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/logo_tonalize.png',
            width: 130, height: 100),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              _exibirQRCodeScannerDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Pesquisar produtos...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Produto>>(
              future: DatabaseProvider.instance.getProdutos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar os produtos do banco de dados.'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum produto encontrado.'),
                  );
                } else {
                  final produtos = snapshot.data!;
                  
                  // Crie duas listas: uma para itens filtrados e outra para itens não filtrados
                  final List<Produto> produtosFiltrados = [];
                  final List<Produto> produtosNaoFiltrados = [];

                  for (final produto in produtos) {
                    if (produto.nome.toLowerCase().contains(searchTerm.toLowerCase())) {
                      produtosFiltrados.add(produto);
                    } else {
                      produtosNaoFiltrados.add(produto);
                    }
                  }

                  // Concatene as duas listas na ordem desejada (filtrados primeiro)
                  final List<Produto> produtosExibidos = [...produtosFiltrados, ...produtosNaoFiltrados];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: produtosExibidos.length,
                      itemBuilder: (context, index) {
                        final produto = produtosExibidos[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesPage(produto: produto),
                              ),
                            );
                          },
                          child: ProdutoItem(produto: produto),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
  floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom: 16.0, right: 16.0), 
    child: FloatingActionButton.extended(
      onPressed: () {
        // Adicione a ação para exibir as combinações existentes aqui
        _exibirCombinacoesDialog(context);
      },
      icon: const Icon(Icons.help_outline), 
      label: const Text('Cores Combinantes'), 
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
);
  }


  void _exibirCombinacoesDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CombinacoesDialog();
    },
  );
}


  Future<void> _exibirQRCodeScannerDialog(BuildContext context) async {
    String? idDoProduto = ''; // Armazenar o ID do produto aqui

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scanner de QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Código do QrCode:'),
              const SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  idDoProduto = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'QrCódigo',
                ),
              ),
              const SizedBox(height: 16.0),
              /*TextField(
                controller: qrCodeController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'QR Code Lido',
                ),
              ),*/
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navegarParaDetalhes(context, idDoProduto);
                },
                child: const Text('Pesquisar'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
              child: const Text('Scan QR Code'),
            ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  void _navegarParaDetalhes(BuildContext context, String? idDoProduto) {
    if (idDoProduto != null && idDoProduto.isNotEmpty) {
      final int id = int.tryParse(idDoProduto) ?? 0;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Produto?>(
            future: DatabaseProvider.instance.getProdutoPorId(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar o produto do banco de dados.'),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text('Produto não encontrado.'),
                );
              } else {
                final produto = snapshot.data!;
                return DetalhesPage(produto: produto);
              }
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um ID de produto válido.'),
        ),
      );
    }
  }
}
