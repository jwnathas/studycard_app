import 'nivel_dominio.dart';

class Flashcard {
  final String id;
  final String moduleId;
  String pergunta;
  String resposta;
  NivelDominio nivelDominio;

  Flashcard({
    required this.id,
    required this.moduleId,
    required this.pergunta,
    required this.resposta,
    this.nivelDominio = NivelDominio.novo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'moduleId': moduleId,
    'pergunta': pergunta,
    'resposta': resposta,
    'nivelDominio': nivelDominio.index,
  };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
    id: json['id'],
    moduleId: json['moduleId'],
    pergunta: json['pergunta'],
    resposta: json['resposta'],
    nivelDominio: NivelDominio.values[json['nivelDominio'] as int],
  );
}
