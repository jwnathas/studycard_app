import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard.dart';
import '../models/study_module.dart';
import '../models/nivel_dominio.dart';

class StudyStore extends ChangeNotifier {
  List<StudyModule> modules = [];
  List<Flashcard> cards = [];
  final _uuid = const Uuid();
  static const _storageKey = 'studycards_data_v2';

  StudyStore() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        final Map<String, dynamic> data = jsonDecode(raw);
        modules = (data['modules'] as List)
            .map((m) => StudyModule.fromJson(m))
            .toList();
        cards = (data['cards'] as List)
            .map((c) => Flashcard.fromJson(c))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erro load: $e");
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'modules': modules.map((m) => m.toJson()).toList(),
      'cards': cards.map((c) => c.toJson()).toList(),
    };
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  // --- Módulos ---
  void createModule(String nome, String? descricao, String cor) {
    modules.insert(
      0,
      StudyModule(
        id: _uuid.v4(),
        nome: nome,
        descricao: descricao,
        cor: cor,
        criadoEm: DateTime.now(),
      ),
    );
    _save();
    notifyListeners();
  }

  void updateModule(String id, String nome, String? descricao, String cor) {
    final index = modules.indexWhere((m) => m.id == id);
    if (index != -1) {
      modules[index].nome = nome;
      modules[index].descricao = descricao;
      modules[index].cor = cor;
      _save();
      notifyListeners();
    }
  }

  void deleteModule(String id) {
    modules.removeWhere((m) => m.id == id);
    cards.removeWhere((c) => c.moduleId == id);
    _save();
    notifyListeners();
  }

  // --- Cards ---
  void createCard(String moduleId, String pergunta, String resposta) {
    cards.add(
      Flashcard(
        id: _uuid.v4(),
        moduleId: moduleId,
        pergunta: pergunta,
        resposta: resposta,
        nivelDominio: NivelDominio.novo,
      ),
    );
    _save();
    notifyListeners();
  }

  void updateCard(String id, String pergunta, String resposta) {
    final index = cards.indexWhere((c) => c.id == id);
    if (index != -1) {
      cards[index].pergunta = pergunta;
      cards[index].resposta = resposta;
      _save();
      notifyListeners();
    }
  }

  void deleteCard(String id) {
    cards.removeWhere((c) => c.id == id);
    _save();
    notifyListeners();
  }

  void updateCardLevel(String cardId, NivelDominio novoNivel) {
    final index = cards.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      cards[index].nivelDominio = novoNivel;
      _save();
      notifyListeners();
    }
  }

  double getModuleProgress(String moduleId) {
    final mCards = cards.where((c) => c.moduleId == moduleId).toList();
    if (mCards.isEmpty) return 0.0;
    return mCards.where((c) => c.nivelDominio == NivelDominio.dominei).length /
        mCards.length;
  }
}
