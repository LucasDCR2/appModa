class Cor {
  int? id;
  String nome;
  String cor; 

  Cor({
    this.id,
    required this.nome,
    required this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cor': cor,
    };
  }
}
