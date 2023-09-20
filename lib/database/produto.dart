import 'dart:typed_data'; 

class Produto {
  int? id; 
  Uint8List? imagem;
  String nome;
  String cor;
  String tamanho;
  double preco;

  Produto({
    this.id, 
    this.imagem, 
    required this.nome,
    required this.cor,
    required this.tamanho,
    required this.preco,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagem': imagem, 
      'nome': nome,
      'cor': cor,
      'tamanho': tamanho,
      'preco': preco,
    };
  }
}
