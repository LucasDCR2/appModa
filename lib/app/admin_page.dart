// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../database/produto.dart';
import '../database/cor.dart';
import 'dart:typed_data';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController tamanhoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();

  Cor? _corSelecionada;
  Uint8List? _imagemBytes;

  List<Cor> listaDeCoresDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _carregarCoresDisponiveis();
  }

  _carregarCoresDisponiveis() async {
    final coresDoBanco = await DatabaseProvider.instance.getCores();
    setState(() {
      listaDeCoresDisponiveis = coresDoBanco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administração'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Conteúdo da Administração aqui'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _mostrarBottomSheet(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Produto'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _excluirProdutosDialog(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Excluir Todos os Produtos'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _mostrarBottomSheet(BuildContext context) {
    nomeController.clear();
    tamanhoController.clear();
    precoController.clear();
    _corSelecionada = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        const SizedBox(height: 20),
                        const Center(
                          child: Text('Preencha as informações do produto:'),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: nomeController,
                          labelText: 'Nome',
                        ),
                        _buildTextField(
                          controller: tamanhoController,
                          labelText: 'Tamanho',
                        ),
                        _buildTextField(
                          controller: precoController,
                          labelText: 'Preço',
                        ),
                        const SizedBox(height: 20),
                        const Center(child: Text('Selecione uma Cor: ')),
                        Padding(
                          padding: const EdgeInsets.all(36.0),
                          child: SizedBox(
                            height: 300,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: listaDeCoresDisponiveis.length,
                              itemBuilder: (context, index) {
                                final cor = listaDeCoresDisponiveis[index];
                                final isSelected = _corSelecionada == cor;
                                final scaleFactor = isSelected ? 1.2 : 1.0;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _corSelecionada = cor;
                                    });
                                  },
                                  child: Transform.scale(
                                    scale: scaleFactor,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(int.parse('0xFF${cor.cor.substring(1)}')),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (nomeController.text.isEmpty ||
                            tamanhoController.text.isEmpty ||
                            precoController.text.isEmpty) {
                          // Se algum dos campos não estiver preenchido, exiba um alerta
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Atenção!'),
                                content: const Text('Campos incompletos'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.of(context).pop(); // Fecha o BottomSheet
                          await _adicionarProduto();
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Adicionar Imagem'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _excluirProdutosDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Todos os Produtos?'),
          content: const Text(
              'Esta ação excluirá todos os produtos. Deseja continuar?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await DatabaseProvider.instance.deleteAllProdutos();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todos os produtos foram excluídos.'),
                  ),
                );
              },
              child: const Text(
                'Sim',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _adicionarProduto() async {
    final nome = nomeController.text;
    final tamanho = tamanhoController.text;

    double preco;

    try {
      preco = double.parse(precoController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um valor de preço válido.'),
        ),
      );
      return;
    }

    final XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();

      if (_corSelecionada != null) {
        final produto = Produto(
          id: null,
          imagem: bytes,
          nome: nome,
          cor: _corSelecionada!.cor,
          tamanho: tamanho,
          preco: preco,
        );

        final db = await DatabaseProvider.instance.database;
        await db.insert('produtos', produto.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto adicionado ao banco de dados.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione uma cor.'),
          ),
        );
      }
    }
  }
}
