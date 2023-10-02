// ignore_for_file: prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tonalize/database/database_helper.dart';

class CombinacoesDialog extends StatefulWidget {
  @override
  _CombinacoesDialogState createState() => _CombinacoesDialogState();
}

class _CombinacoesDialogState extends State<CombinacoesDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Cores Combinantes', style: TextStyle(fontSize: 22, color: Colors.black)),
                const SizedBox(height: 10),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseProvider.instance.carregarCombinacoesDoBanco(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Erro ao carregar as combinações');
                    } else if (!snapshot.hasData) {
                      return const Text('Nenhuma combinação disponível');
                    } else {
                      final combinacoes = snapshot.data!;
                      return Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: combinacoes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final combinacao = combinacoes[index];
    
                            final codigoCorPrincipal = combinacao['codigoCorPrincipal'];
                            final codigoCorCombinante = combinacao['codigoCorCombinante'];
                            final nomeCorPrincipal = combinacao['corPrincipal'];
                            final nomeCorCombinante = combinacao['corCombinante'];
    
                            final corPrincipal = Color(int.parse('0xFF' + codigoCorPrincipal.substring(1)));
                            final corCombinante = Color(int.parse('0xFF' + codigoCorCombinante.substring(1)));

                            int displayIndex = index + 1;
    
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                Text('Combinação $displayIndex', style: const TextStyle(fontSize: 18, color: Colors.black)),
                                const SizedBox(height: 20),
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
                                                BorderRadius.circular(40.0),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(nomeCorPrincipal, style: const TextStyle(fontSize: 16, color: Colors.black),),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: corCombinante,
                                            borderRadius: BorderRadius.circular(40.0),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(nomeCorCombinante, style: const TextStyle(fontSize: 16, color: Colors.black),),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
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
      ),
    );
  }
}
