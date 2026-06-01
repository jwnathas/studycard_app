import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard.dart';
import '../models/study_module.dart';
import '../models/nivel_dominio.dart';

class StudyStore extends ChangeNotifier {
  //vai guardar os dados dos módulos e flashcards, além de fornecer métodos para manipular esses dados e persistir as mudanças usando SharedPreferences.
  List<StudyModule> modules =
      []; //guarda os módulos de estudo criados pelo usuário, cada um contendo informações como nome, descrição, cor e data de criação.
  List<Flashcard> cards =
      []; //guarda os flashcards criados pelo usuário, cada um contendo informações como pergunta, resposta, nível de domínio e o ID do módulo ao qual pertence.
  final _uuid =
      const Uuid(); //utilizado para gerar IDs únicos para módulos e flashcards, garantindo que cada item tenha um identificador distinto.
  static const _storageKey =
      'studycards_data_v2'; //chave usada para armazenar e recuperar os dados do SharedPreferences, permitindo que o aplicativo salve o estado atual dos módulos e flashcards entre sessões.

  StudyStore() {
    //construtor da classe, que é chamado quando uma instância de StudyStore é criada. Ele chama o método _loadFromPrefs() para carregar os dados salvos anteriormente do SharedPreferences, garantindo que o estado do aplicativo seja restaurado corretamente quando o usuário abrir o aplicativo novamente.
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    //método privado responsável por carregar os dados salvos do SharedPreferences. Ele tenta recuperar a string JSON armazenada usando a chave _storageKey, decodifica essa string em um mapa de dados e, em seguida, converte as listas de módulos e flashcards de volta para seus respectivos objetos usando os métodos fromJson. Se ocorrer algum erro durante esse processo, ele é capturado e impresso no console para depuração.
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
    //método privado responsável por salvar os dados atuais dos módulos e flashcards no SharedPreferences. Ele converte as listas de módulos e flashcards em uma estrutura de dados JSON, codifica essa estrutura em uma string e a armazena usando a chave _storageKey. Se ocorrer algum erro durante esse processo, ele é capturado e impresso no console para depuração.
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'modules': modules.map((m) => m.toJson()).toList(),
      'cards': cards.map((c) => c.toJson()).toList(),
    };
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  // --- Módulos ---
  void createModule(String nome, String? descricao, String cor) {
    //método público para criar um novo módulo de estudo. Ele recebe o nome, descrição e cor do módulo como parâmetros, gera um ID único usando o pacote uuid, define a data de criação como a data atual e adiciona o novo módulo à lista de módulos. Após adicionar o módulo, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
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
    notifyListeners(); //notifica os ouvintes sobre a atualização dos dados, permitindo que a interface do usuário seja atualizada para refletir as mudanças feitas na lista de módulos.
  }

  void updateModule(String id, String nome, String? descricao, String cor) {
    //método público para atualizar um módulo existente. Ele recebe o ID do módulo e os novos valores para nome, descrição e cor como parâmetros. Ele encontra o índice do módulo na lista de módulos e atualiza seus atributos. Após a atualização, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
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
    //método público para excluir um módulo existente. Ele recebe o ID do módulo como parâmetro e remove o módulo da lista de módulos. Além disso, ele remove todos os flashcards associados a esse módulo. Após a exclusão, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
    modules.removeWhere((m) => m.id == id);
    cards.removeWhere((c) => c.moduleId == id);
    _save();
    notifyListeners();
  }

  // --- Cards ---
  void createCard(String moduleId, String pergunta, String resposta) {
    //método público para criar um novo flashcard. Ele recebe o ID do módulo ao qual o flashcard pertence, além da pergunta e resposta como parâmetros. Ele gera um ID único usando o pacote uuid e adiciona o novo flashcard à lista de flashcards. Após adicionar o flashcard, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
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
    //método público para atualizar um flashcard existente. Ele recebe o ID do flashcard e os novos valores para pergunta e resposta como parâmetros. Ele encontra o índice do flashcard na lista de flashcards e atualiza seus atributos. Após a atualização, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
    final index = cards.indexWhere((c) => c.id == id);
    if (index != -1) {
      cards[index].pergunta = pergunta;
      cards[index].resposta = resposta;
      _save();
      notifyListeners();
    }
  }

  void deleteCard(String id) {
    //método público para excluir um flashcard existente. Ele recebe o ID do flashcard como parâmetro e remove o flashcard da lista de flashcards. Após a exclusão, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
    cards.removeWhere((c) => c.id == id);
    _save();
    notifyListeners();
  }

  void updateCardLevel(String cardId, NivelDominio novoNivel) {
    //método público para atualizar o nível de domínio de um flashcard existente. Ele recebe o ID do flashcard e o novo nível de domínio como parâmetros. Ele encontra o índice do flashcard na lista de flashcards e atualiza seu atributo nivelDominio. Após a atualização, ele chama o método _save() para persistir as mudanças no SharedPreferences e notifyListeners() para notificar os ouvintes sobre a atualização dos dados.
    final index = cards.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      cards[index].nivelDominio = novoNivel;
      _save();
      notifyListeners();
    }
  }

  double getModuleProgress(String moduleId) {
    //método público para calcular o progresso de um módulo com base no nível de domínio dos flashcards associados a ele. Ele recebe o ID do módulo como parâmetro, filtra os flashcards para obter apenas aqueles que pertencem ao módulo especificado e calcula a proporção de flashcards que estão no nível de domínio "dominei" em relação ao total de flashcards do módulo. Se não houver flashcards para o módulo, ele retorna 0.0 para evitar divisão por zero.
    final mCards = cards.where((c) => c.moduleId == moduleId).toList();
    if (mCards.isEmpty) return 0.0;
    return mCards.where((c) => c.nivelDominio == NivelDominio.dominei).length /
        mCards.length;
  }
}
