// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:tonalize/database/cor.dart';

class GerenciarCoresPage extends StatefulWidget {

  @override
  _GerenciarCoresPageState createState() => _GerenciarCoresPageState();
}

class _GerenciarCoresPageState extends State<GerenciarCoresPage> {
  Cor? _corSelecionada;
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

  Future<void> _excluirTodasCoresDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir todas as cores?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Excluir todas as cores
                await DatabaseProvider.instance.deleteAllCores();
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirTodasCombinacoesDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text(
              'Tem certeza de que deseja excluir todas as combinações de cores?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Excluir todas as combinações de cores
                await DatabaseProvider.instance.deleteAllCoresCombinantes();
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

Future<void> _excluirCorDialog(BuildContext context, List<Cor> coresDisponiveis, Cor? corSelecionada) async {
  String? nomeCor;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Excluir Cor'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Selecione a Cor a Ser Excluída:'),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: coresDisponiveis.map((cor) {
                    final isSelected = corSelecionada == cor;
                
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            corSelecionada = cor;
                            nomeCor = corSelecionada != null ? corSelecionada!.nome : '';
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(int.parse('0xFF${cor.cor.substring(1)}')),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (nomeCor != null && nomeCor!.isNotEmpty) {
                // Excluir a cor com o nome especificado
                //await DatabaseProvider.instance.deleteCor(nomeCor!);
                Navigator.of(context).pop();
              }
            },
            child: Text('Excluir'),
          ),
        ],
      );
    },
  );
}



  Future<void> _excluirCombinacaoDialog(BuildContext context) async {
    String? nomeCombinacao;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Combinação'),
          content: TextField(
            onChanged: (value) {
              nomeCombinacao = value;
            },
            decoration: InputDecoration(labelText: 'Nome da Combinação'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nomeCombinacao != null && nomeCombinacao!.isNotEmpty) {
                  // Excluir a combinação com o nome especificado
                  //await DatabaseProvider.instance.deleteCombinacao(nomeCombinacao!);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Cores'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _excluirCorDialog(context, listaDeCoresDisponiveis, _corSelecionada);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text('Excluir uma Cor'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _excluirCombinacaoDialog(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text('Excluir uma Combinação'),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _excluirTodasCoresDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text('Excluir Todas as Cores'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _excluirTodasCombinacoesDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(16),
              ),
              child: Text('Excluir Todas as Combinações'),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
