import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/study_store.dart';
import '../models/flashcard.dart';
import '../models/study_module.dart';
import '../models/nivel_dominio.dart';
import '../theme/app_colors.dart';
import '../widgets/flip_card.dart';

class StudySessionScreen extends StatefulWidget {
  final StudyModule module;
  final List<Flashcard> sessionCards;

  const StudySessionScreen({
    super.key,
    required this.module,
    required this.sessionCards,
  });

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  int _currentIndex = 0;
  bool _isFlipped = false;

  void _handleNext(NivelDominio nivel) {
    // Atualiza o nível do card no "Cérebro" do App
    context.read<StudyStore>().updateCardLevel(
      widget.sessionCards[_currentIndex].id,
      nivel,
    );

    if (_currentIndex < widget.sessionCards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
    } else {
      _showFinishDialog();
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Sessão Finalizada!',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text('Você revisou todos os cards deste módulo.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha dialog
              Navigator.pop(context); // Volta para detalhe
            },
            child: const Text(
              'CONCLUIR',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.sessionCards[_currentIndex];
    final double progress = (_currentIndex + 1) / widget.sessionCards.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Estudando',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.module.nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de Progresso da Sessão
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Card 3D
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () => setState(() => _isFlipped = !_isFlipped),
              child: SizedBox(
                height: 380,
                width: double.infinity,
                child: FlipCard(
                  isFlipped: _isFlipped,
                  front: _buildCardFace(
                    currentCard.pergunta,
                    'PERGUNTA',
                    AppColors.primary,
                  ),
                  back: _buildCardFace(
                    currentCard.resposta,
                    'RESPOSTA',
                    AppColors.green,
                  ),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              'Toque no card para virar',
              style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
            ),
          ),

          const Spacer(),

          // Botões de Nível (Só aparecem quando o card está virado)
          AnimatedOpacity(
            opacity: _isFlipped ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: _isFlipped
                ? _buildLevelButtons()
                : const SizedBox(height: 100),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildCardFace(String text, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _levelButton('ERREI', AppColors.blue, NivelDominio.naoAprendi),
          const SizedBox(width: 12),
          _levelButton('DÚVIDA', AppColors.orange, NivelDominio.emDuvida),
          const SizedBox(width: 12),
          _levelButton('DOMINEI', AppColors.green, NivelDominio.dominei),
        ],
      ),
    );
  }

  Widget _levelButton(String label, Color color, NivelDominio nivel) {
    return Expanded(
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: () => _handleNext(nivel),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
