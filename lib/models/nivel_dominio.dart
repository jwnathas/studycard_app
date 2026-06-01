import 'package:flutter/material.dart';

enum NivelDominio {
  novo,
  naoAprendi,
  emDuvida,
  dominei,
} //enum que representa os diferentes níveis de domínio que um flashcard pode ter, indicando o quanto o usuário se sente confortável com o conteúdo do flashcard. Os níveis incluem "novo", "não aprendi", "em dúvida" e "dominei", permitindo que os usuários classifiquem seus flashcards com base em seu conhecimento e confiança em relação ao conteúdo.

extension NivelDominioX on NivelDominio {
  //extensão da enumeração NivelDominio, que adiciona métodos para obter o rótulo (label) e a cor associada a cada nível de domínio. O método label retorna uma string descritiva para cada nível, enquanto o método color retorna uma cor específica para cada nível, facilitando a visualização do progresso do usuário em relação aos flashcards.
  String get label => switch (this) {
    NivelDominio.novo => 'Novo',
    NivelDominio.naoAprendi => 'Não aprendi',
    NivelDominio.emDuvida => 'Em dúvida',
    NivelDominio.dominei => 'Dominei',
  };

  Color get color => switch (this) {
    //método que retorna uma cor específica para cada nível de domínio, facilitando a visualização do progresso do usuário em relação aos flashcards. As cores são definidas usando a classe Colors do Flutter, com cinza para "novo", vermelho para "não aprendi", laranja para "em dúvida" e verde para "dominei".
    NivelDominio.novo => Colors.grey,
    NivelDominio.naoAprendi => Colors.red,
    NivelDominio.emDuvida => Colors.orange,
    NivelDominio.dominei => Colors.green,
  };
}
