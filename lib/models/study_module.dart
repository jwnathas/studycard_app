class StudyModule {
  //classe que representa um módulo de estudo. Ela possui os seguintes atributos: id (identificador único do módulo), nome (nome do módulo), descricao (descrição opcional do módulo), cor (cor associada ao módulo) e criadoEm (data de criação do módulo). O construtor da classe exige que o id, nome, cor e criadoEm sejam fornecidos, enquanto a descrição é opcional. A classe também inclui métodos toJson e fromJson para facilitar a conversão entre objetos StudyModule e mapas JSON, o que é útil para persistência de dados.
  final String id;
  String nome; // Removido o 'final' para permitir edição
  String? descricao; // Removido o 'final'
  String cor; // Removido o 'final'
  final DateTime criadoEm;

  StudyModule({
    //construtor da classe StudyModule, que recebe os parâmetros necessários para criar um módulo de estudo. O ID do módulo é obrigatório, assim como o nome, cor e data de criação. A descrição é opcional, permitindo que os usuários forneçam informações adicionais sobre o módulo, mas não é obrigatória para a criação do módulo.
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
    //método de fábrica para criar um módulo de estudo a partir de um formato JSON. Ele recebe um mapa de chaves e valores e retorna uma instância da classe StudyModule, preenchendo os atributos com os valores correspondentes do JSON. A data de criação é convertida de uma string no formato ISO 8601 para um objeto DateTime.
    id: json['id'],
    nome: json['nome'],
    descricao: json['descricao'],
    cor: json['cor'],
    criadoEm: DateTime.parse(json['criadoEm']),
  );
}
