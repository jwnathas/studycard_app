import 'package:flutter/material.dart';

enum NivelDominio { novo, naoAprendi, emDuvida, dominei }

extension NivelDominioX on NivelDominio {
  String get label => switch (this) {
    NivelDominio.novo => 'Novo',
    NivelDominio.naoAprendi => 'Não aprendi',
    NivelDominio.emDuvida => 'Em dúvida',
    NivelDominio.dominei => 'Dominei',
  };

  Color get color => switch (this) {
    NivelDominio.novo => Colors.grey,
    NivelDominio.naoAprendi => Colors.red,
    NivelDominio.emDuvida => Colors.orange,
    NivelDominio.dominei => Colors.green,
  };
}
