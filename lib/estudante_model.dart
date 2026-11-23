class Estudante {
  final int? id;
  final String nome;
  final String ra;
  final String bloco;

  Estudante({
    this.id,
    required this.nome,
    required this.ra,
    required this.bloco,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'ra': ra,
      'bloco': bloco,
    };
  }

  factory Estudante.fromMap(Map<String, Object?> map) {
    return Estudante(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      ra: map['ra'] as String,
      bloco: map['bloco'] as String,
    );
  }
}