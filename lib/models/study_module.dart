class StudyModule {
  final String id;
  String nome; // Removido o 'final' para permitir edição
  String? descricao; // Removido o 'final'
  String cor; // Removido o 'final'
  final DateTime criadoEm;

  StudyModule({
    required this.id,
    required this.nome,
    this.descricao,
    required this.cor,
    required this.criadoEm,
  });

  // Garanta que seu toJson e fromJson acompanhem essas mudanças se necessário
  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'descricao': descricao,
    'cor': cor,
    'criadoEm': criadoEm.toIso8601String(),
  };

  factory StudyModule.fromJson(Map<String, dynamic> json) => StudyModule(
    id: json['id'],
    nome: json['nome'],
    descricao: json['descricao'],
    cor: json['cor'],
    criadoEm: DateTime.parse(json['criadoEm']),
  );
}
