import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/study_store.dart';
import '../models/study_module.dart';
import '../models/flashcard.dart';
import '../models/nivel_dominio.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_header.dart';
import 'study_session_screen.dart';

class ModuleDetailScreen extends StatelessWidget {
  final StudyModule module;

  const ModuleDetailScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StudyStore>();

    final List<Flashcard> moduleCards = store.cards
        .where((c) => c.moduleId == module.id)
        .toList()
        .cast<Flashcard>();

    final total = moduleCards.length;
    final duvida = moduleCards
        .where((c) => c.nivelDominio == NivelDominio.emDuvida)
        .length;
    final dominei = moduleCards
        .where((c) => c.nivelDominio == NivelDominio.dominei)
        .length;
    final double progress = total == 0 ? 0 : dominei / total;

    final double topSpacing = MediaQuery.of(context).padding.top + 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, topSpacing + 10, 20, 112),
        children: [
          // Header alinhado em linha para evitar quebra de layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: AppColors.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.foreground,
                        height: 1.1,
                      ),
                    ),
                    if (module.descricao != null &&
                        module.descricao!.isNotEmpty)
                      Text(
                        module.descricao!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              _buildStatCard('TOTAL', total.toString(), AppColors.blue),
              const SizedBox(width: 12),
              _buildStatCard('DÚVIDA', duvida.toString(), AppColors.orange),
              const SizedBox(width: 12),
              _buildStatCard('DOMINEI', dominei.toString(), AppColors.green),
            ],
          ),
          const SizedBox(height: 16),

          _buildProgressCard(progress),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Novo card',
                  icon: LucideIcons.plus,
                  isFilled: false,
                  onTap: () => _showAddCardSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  label: 'Estudar',
                  icon: LucideIcons.play,
                  isFilled: true,
                  onTap: total > 0
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => StudySessionScreen(
                              module: module,
                              sessionCards: moduleCards,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          ...moduleCards.map((card) => _buildFlashcardItem(context, card)),
        ],
      ),
      // CORREÇÃO: Agora passamos o context para o método
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.mutedForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.secondary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isFilled,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: isFilled ? AppColors.primaryGradient : null,
        borderRadius: BorderRadius.circular(16),
        border: isFilled ? null : Border.all(color: AppColors.border),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: isFilled ? Colors.white : AppColors.foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardItem(BuildContext context, Flashcard card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getNivelColor(card.nivelDominio),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.pergunta,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  card.resposta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  LucideIcons.pencil,
                  size: 18,
                  color: AppColors.mutedForeground,
                ),
                onPressed: () => _showAddCardSheet(context, editing: card),
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.trash2,
                  size: 18,
                  color: Colors.redAccent,
                ),
                onPressed: () => _confirmDeletion(
                  context,
                  () => context.read<StudyStore>().deleteCard(card.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getNivelColor(NivelDominio nivel) {
    switch (nivel) {
      case NivelDominio.dominei:
        return AppColors.green;
      case NivelDominio.emDuvida:
        return AppColors.orange;
      case NivelDominio.naoAprendi:
        return AppColors.red;
      default:
        return AppColors.border;
    }
  }

  void _confirmDeletion(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Excluir card?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('Tem certeza que deseja apagar este flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: AppColors.mutedForeground),
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text(
              'EXCLUIR',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardSheet(BuildContext context, {Flashcard? editing}) {
    final perguntaController = TextEditingController(text: editing?.pergunta);
    final respostaController = TextEditingController(text: editing?.resposta);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  editing == null ? 'Novo card' : 'Editar card',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Pergunta (frente)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: perguntaController,
              decoration: InputDecoration(
                hintText: 'Digite a pergunta...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.input),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resposta (verso)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: respostaController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Digite a resposta...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.input),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (perguntaController.text.isNotEmpty &&
                      respostaController.text.isNotEmpty) {
                    if (editing == null) {
                      context.read<StudyStore>().createCard(
                        module.id,
                        perguntaController.text,
                        respostaController.text,
                      );
                    } else {
                      context.read<StudyStore>().updateCard(
                        editing.id,
                        perguntaController.text,
                        respostaController.text,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  editing == null ? 'Criar card' : 'Salvar',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método agora recebe context para funcionar corretamente
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mutedForeground,
        currentIndex: 0,
        onTap: (index) => Navigator.pop(context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layers, size: 20),
            label: 'Módulos',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bookOpen, size: 20),
            label: 'Estudar',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.info, size: 20),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}
