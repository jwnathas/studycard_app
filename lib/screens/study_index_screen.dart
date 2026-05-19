import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/study_store.dart';
import '../models/study_module.dart';
import '../models/flashcard.dart';
import '../models/nivel_dominio.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_header.dart';
import 'study_session_screen.dart';

class StudyIndexScreen extends StatelessWidget {
  const StudyIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StudyStore>();

    // Medidas Canônicas da Especificação da Seção 1 e 9
    final double topSpacing = MediaQuery.of(context).padding.top + 60.0;

    // Força a conversão segura da lista para garantir estabilidade no runtime
    final List<StudyModule> allModules = store.modules.cast<StudyModule>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(),
      extendBodyBehindAppBar: true,
      body: ListView(
        // Padding da especificação técnica: 20px laterais, 16px topo, 112px base
        padding: EdgeInsets.fromLTRB(20.0, topSpacing + 16.0, 20.0, 112.0),
        children: [
          // 3. Seção de Cabeçalho com Tipografia Homologada
          Text(
            "MODO ESTUDO",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500, // Medium
              color: AppColors.mutedForeground,
              letterSpacing: 0.6, // tracking-wider (~+0.05em)
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Escolha um módulo",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700, // Bold
              color: AppColors.foreground,
              letterSpacing: -0.36, // tracking-tight (~-0.015em)
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Comece uma sessão de revisão.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 20), // Gap vertical de 20px (space-y-5)
          // 5. Lista de Módulos com Garantia de Tipagem <Widget>
          if (allModules.isEmpty)
            const _EmptyStateWidget()
          else
            // SOLUÇÃO: O uso explícito de .map<Widget> impede o colapso e o erro de cast no Dart
            ...allModules.map<Widget>((module) {
              final List<Flashcard> moduleCards = store.cards
                  .where((c) => c.moduleId == module.id)
                  .toList()
                  .cast<Flashcard>();

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ), // space-y-2 (8px entre itens)
                child: _ModuleStudyTile(module: module, cards: moduleCards),
              );
            }),
        ],
      ),
    );
  }
}

// 5.1 Card do Módulo com Efeito de Toque por Escala Animada
class _ModuleStudyTile extends StatefulWidget {
  final StudyModule module;
  final List<Flashcard> cards;

  const _ModuleStudyTile({required this.module, required this.cards});

  @override
  State<_ModuleStudyTile> createState() => _ModuleStudyTileState();
}

class _ModuleStudyTileState extends State<_ModuleStudyTile> {
  bool _isPressed = false;

  Color _getCorSemantic(String corNome) {
    switch (corNome) {
      case 'purple':
        return AppColors.purple;
      case 'green':
        return AppColors.green;
      case 'orange':
        return AppColors.orange;
      case 'red':
        return AppColors.red;
      default:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.cards.length;

    // Cálculo do progresso real usando comparação tipada e segura do Enum
    int percent = 0;
    if (total > 0) {
      final masteredCount = widget.cards
          .where((c) => c.nivelDominio == NivelDominio.dominei)
          .length;
      percent = ((masteredCount / total) * 100).round();
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        if (widget.cards.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudySessionScreen(
                module: widget.module,
                sessionCards: widget.cards,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'O módulo "${widget.module.nome}" não possui cards para estudar ainda.',
              ),
              backgroundColor: AppColors.foreground,
            ),
          );
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.99 : 1.0, // Feedback tátil scale(0.99) da Seção 8
        duration: const Duration(milliseconds: 80),
        child: Container(
          padding: const EdgeInsets.all(16), // Padding 16px em todos os lados
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              16,
            ), // Border-radius de 16px (rounded-2xl)
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF462896,
                ).withValues(alpha: 0.06), // Sombra suave da marca
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 5.1.1 Quadrado do Ícone (44x44)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getCorSemantic(
                    widget.module.cor,
                  ), // Cor semântica dinâmica do módulo
                  borderRadius: BorderRadius.circular(12), // radius 12px
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons
                      .menu_book_outlined, // Ícone BookOpen Material equivalente
                  size: 20,
                  color: Colors.white, // var(--primary-foreground)
                ),
              ),
              const SizedBox(width: 12), // Gap interno de 12px
              // 5.1.2 Bloco de Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.module.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600, // Semibold
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$total cards  •  $percent% dominado", // String e caractere bullet literal
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5.2 Estado Vazio Customizado
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32), // Padding 32px
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      alignment: Alignment.center,
      child: const Text(
        "Crie um módulo primeiro.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}
