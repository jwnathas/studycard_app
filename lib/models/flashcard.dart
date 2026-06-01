import 'nivel_dominio.dart';

class Flashcard {
  //representa um flashcard individual dentro do aplicativo, contendo informações como a pergunta, resposta, nível de domínio e o ID do módulo ao qual pertence. Ele inclui métodos para converter o flashcard em um formato JSON para armazenamento e para criar um flashcard a partir de um formato JSON, facilitando a persistência dos dados usando SharedPreferences.
  final String id;
  final String moduleId;
  String pergunta;
  String resposta;
  NivelDominio nivelDominio;

  Flashcard({
    //construtor da classe Flashcard, que recebe os parâmetros necessários para criar um flashcard. O ID do flashcard é obrigatório, assim como o ID do módulo ao qual ele pertence, a pergunta e a resposta. O nível de domínio é opcional e tem um valor padrão de NivelDominio.novo.
    required this.id,
    required this.moduleId,
    required this.pergunta,
    required this.resposta,
    this.nivelDominio = NivelDominio.novo,
  });

  Map<String, dynamic> toJson() => {
    //método para converter um flashcard em um formato JSON, que é um mapa de chaves e valores. Ele inclui o ID do flashcard, o ID do módulo, a pergunta, a resposta e o nível de domínio (representado como um índice inteiro).
    'id': id,
    'moduleId': moduleId,
    'pergunta': pergunta,
    'resposta': resposta,
    'nivelDominio': nivelDominio.index,
  };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
    //método de fábrica para criar um flashcard a partir de um formato JSON. Ele recebe um mapa de chaves e valores e retorna uma instância da classe Flashcard, preenchendo os atributos com os valores correspondentes do JSON. O nível de domínio é convertido de um índice inteiro para o valor correspondente na enumeração NivelDominio.
    id: json['id'],
    moduleId: json['moduleId'],
    pergunta: json['pergunta'],
    resposta: json['resposta'],
    nivelDominio: NivelDominio.values[json['nivelDominio'] as int],
  );
}
