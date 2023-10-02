// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tonalize/database/produto.dart';
import 'package:tonalize/app/widgets/qrcode_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';


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
                          Text(produto.nome),
                          Text('Cor: ${produto.corNome}'),
                          Text('Código QrCode: ${produto.id}'),
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
                          _exibirQRCodeDialog(context, qrCodeData, produto);
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

Future<void> _exibirQRCodeDialog(BuildContext context, int qrCodeData, Produto produto) async {
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
              Image.asset('images/logo_tonalize.png', width: 200, height: 100),
              qrImageWidget,
              const SizedBox(height: 40.0),
              Text(produto.nome, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40.0),
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
                      Navigator.of(context).pop(); // Fecha o diálogo
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => TelaExibicaoImagem(
                            imageProvider: const AssetImage('images/logo_tonalize.png'),
                            qrCodeWidget: qrImageWidget,
                            produtoNome: produto.nome,
                          ),
                        ),
                      );
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


class TelaExibicaoImagem extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget qrCodeWidget;
  final String produtoNome;
  final ScreenshotController screenshotController = ScreenshotController();

  TelaExibicaoImagem({
    required this.imageProvider,
    required this.qrCodeWidget,
    required this.produtoNome,
  });

  Future<void> _saveImageToGallery(BuildContext context) async {
    try {
      final imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        final result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageBytes));

        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Imagem salva na galeria com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar a imagem na galeria.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao salvar a imagem: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Screenshot(
      controller: screenshotController,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/img_branca.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Image(
                  image: imageProvider,
                  width: 220, 
                  height: 120, 
                ),
                qrCodeWidget,
                SizedBox(height: 40.0),
                Text(
                  produtoNome,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _saveImageToGallery(context),
      child: Icon(Icons.save),
    ),
  );
}


  
}


