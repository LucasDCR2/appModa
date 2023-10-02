// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, prefer_interpolation_to_compose_strings

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
                              color: isSelected ? Colors.transparent : Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(nomeCor ?? '',),
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
                  int? corId = obterCorIdPeloNome(nomeCor!, coresDisponiveis);
                  if (corId != null) {
                    debugPrint("ID da cor a ser excluída: $corId");
                    await DatabaseProvider.instance.deleteCor(corId);
                    _carregarCoresDisponiveis();
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  int? obterCorIdPeloNome(String nomeCor, List<Cor> coresDisponiveis) {
    for (var cor in coresDisponiveis) {
      if (cor.nome == nomeCor) {
        return cor.id;
      }
    }
    return null;
  }

void _excluirCombinacaoDialog(BuildContext context) {
  int? combinacaoId;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Excluir Combinação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                // Atribua o valor do campo de texto diretamente à variável combinacaoId
                  combinacaoId = int.tryParse(value);
                },
                decoration: InputDecoration(labelText: 'Número da Combinação'),
              ),
              SizedBox(height: 20),
            ],
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
              if (combinacaoId != null) {
                // Chame a função para excluir a combinação no banco de dados
                await DatabaseProvider.instance.deleteCorCombinante(combinacaoId!);
                await DatabaseProvider.instance.carregarCombinacoesDoBanco();
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

void _exibirCombinacoesDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Combinações Existentes',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: DatabaseProvider.instance.carregarCombinacoesDoBanco(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao carregar as combinações');
                      } else if (!snapshot.hasData) {
                        return Text('Nenhuma combinação disponível');
                      } else {
                        final combinacoes = snapshot.data!;
                        return Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: combinacoes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final combinacao = combinacoes[index];

                              final codigoCorPrincipal =combinacao['codigoCorPrincipal'];
                              final codigoCorCombinante =combinacao['codigoCorCombinante'];
                              final nomeCorPrincipal =combinacao['corPrincipal'];
                              final nomeCorCombinante =combinacao['corCombinante'];

                              final corPrincipal = Color(int.parse(
                                  '0xFF' + codigoCorPrincipal.substring(1)));
                              final corCombinante = Color(int.parse(
                                  '0xFF' + codigoCorCombinante.substring(1)));

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 40),
                                  Text('Combinação $index',
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: corPrincipal,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: Colors
                                                    .grey, 
                                                width: 1.0, 
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  10), 
                                          Text(
                                              nomeCorPrincipal), 
                                        ],
                                      ),
                                      SizedBox(
                                          width:
                                              20), 
                                      Column(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: corCombinante,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Cor da borda cinza
                                                width: 1.0, // Largura da borda
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10), 
                                          Text(nomeCorCombinante), 
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          20), 
                                ],
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
            ),
          ),
        ),
      );
    },
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Image.asset('images/logo_tonalize.png',
            width: 130, height: 100),
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
              _carregarCoresDisponiveis();
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Adicione a ação para exibir as combinações existentes aqui
              _exibirCombinacoesDialog(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(16),
            ),
            child: Text('Exibir Combinações Existentes'),
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
            child: Text('Excluir Todas as Cores', style: TextStyle(color: Colors.white)),
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
            child: Text('Excluir Todas as Combinações', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 40),
        ],
      ),
    ),
  );
}
}
