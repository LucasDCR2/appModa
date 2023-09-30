// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../database/produto.dart';
import '../database/database_helper.dart';
import 'widgets/widget_produtos_catalogo.dart';
import 'detalhes.dart';
import 'package:tonalize/app/widgets/widget_combinacoes_cores.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';


class CatalogoPage extends StatefulWidget {
  const CatalogoPage({Key? key}) : super(key: key);

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final TextEditingController qrCodeController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String searchTerm = ''; // Termo de pesquisa
  //String qrCodeResult = '';
  String idDoProduto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/logo_tonalize.png', width: 130, height: 100),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              _exibirQRCodeScannerDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit), // Substitua 'outlined_icon_aqui' pelo ícone desejado
            onPressed: () {
              _exibirQRCodeInputDialog(context);
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
  final qrKey = GlobalKey(debugLabel: 'QR');
  bool dialogOpen = true; // Variável para rastrear se o diálogo está aberto

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          // Impedir o fechamento do diálogo usando o botão de voltar
          return false;
        },
        child: AlertDialog(
          title: const Text('Escaneie o Código QR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white, // Cor de fundo do diálogo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Borda arredondada
          ),
          content: SizedBox(
            width: 300,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                controller.scannedDataStream.listen((scanData) {
                  if (dialogOpen) {
                    dialogOpen = false; // Marque o diálogo como fechado
                    Navigator.pop(context); // Feche o diálogo de escaneamento
                    if (scanData != null) {
                      _navegarParaDetalhes(context, scanData.code);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nenhum código QR foi detectado.'),
                        ),
                      );
                    }
                  }
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (dialogOpen) {
                  dialogOpen = false; // Marque o diálogo como fechado
                  Navigator.pop(context);
                }
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    },
  );
}




void _navegarParaDetalhes(BuildContext context, String? idDoProduto) async {
  if (idDoProduto != null && idDoProduto.isNotEmpty) {
    final int id = int.tryParse(idDoProduto) ?? 0;

    final produtoExiste = await DatabaseProvider.instance.verificaProdutoExiste(id);

    if (produtoExiste) {
      final produto = await DatabaseProvider.instance.getProdutoPorId(id);
      if (produto != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetalhesPage(produto: produto),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar os detalhes do produto.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Code inválido.'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, insira um ID de produto válido.'),
      ),
    );
  }
}


Future<void> _exibirQRCodeInputDialog(BuildContext context) async {
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
            ElevatedButton(
              onPressed: () {
                if (idDoProduto != null) {
                  Navigator.of(context).pop();
                  _navegarParaDetalhes(context, idDoProduto);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Por favor, insira um ID de produto válido.'),
                    ),
                  );
                }
              },
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      );
    },
  );
}
}
