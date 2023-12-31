// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';
import 'package:barcode/barcode.dart';

class Produto {
  int? id;
  Uint8List? imagem;
  String nome;
  String cor;
  String corNome;
  String? qrCode; // Propriedade para armazenar o código QR

  Produto({
    this.id,
    this.imagem,
    required this.nome,
    required this.cor,
    required this.corNome,
    this.qrCode, // Inicialize como nulo
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagem': imagem,
      'nome': nome,
      'cor': cor,
      'corNome': corNome,
      'qrCode': qrCode,
    };
  }

String gerarQRCode(String productId) {
  final qr = Barcode.qrCode();
  return qr.toSvg(productId, width: 200, height: 200);
}

}
