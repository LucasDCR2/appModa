import 'dart:typed_data'; 

class Produto {
  int? id; 
  Uint8List? imagem;
  String nome;
  String cor;
  String corNome; 
  String tamanho;
  double preco;

  Produto({
    this.id, 
    this.imagem, 
    required this.nome,
    required this.cor,
    required this.corNome, 
    required this.tamanho,
    required this.preco,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagem': imagem, 
      'nome': nome,
      'cor': cor,
      'corNome': corNome, 
      'tamanho': tamanho,
      'preco': preco,
    };
  }
}

