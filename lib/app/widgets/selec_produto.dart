// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:tonalize/database/produto.dart';
import 'package:tonalize/app/widgets/qrcode_widget.dart';


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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${produto.id}'),
                          Text(produto.nome),
                          Text('Cor: ${produto.corNome}'),
                          Text(
                              'Preço: R\$ ${produto.preco.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(58.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          final qrCodeData = produto.id ?? 0; // Suponho que o ID seja um int
                          debugPrint("QR Code Data: $qrCodeData");
                          _exibirQRCodeDialog(context, qrCodeData);
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        color: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        iconSize: 35.0,
                        splashColor: Colors.blue,
                        tooltip: 'QR Code',
                      ),
                    ),
                    if (produto.imagem != null)
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.memory(
                          produto.imagem!,
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop(produto);
                },
              ),
            );
          },
        ),
      ),
    );
  }

Future<void> _exibirQRCodeDialog(BuildContext context, int qrCodeData) async {
  final qrImageWidget = ProductQRCodeWidget(qrCodeData: qrCodeData);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Código QR'),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            qrImageWidget,
            const SizedBox(height: 70.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                  ),
                  child: const Text('Fechar'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Implemente aqui a lógica para salvar o QR Code
                    // Pode usar plugins como path_provider para salvar a imagem no dispositivo
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


}
