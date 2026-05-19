import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/study_store.dart';
import '../models/study_module.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_header.dart';
import 'module_detail_screen.dart';

class ModuleListScreen extends StatelessWidget {
  const ModuleListScreen({super.key});

  static const double kRadiusCard = 22.0;
  static const double kPagePaddingX = 20.0;
  static const double kHeaderHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StudyStore>();
    final double topSpacing =
        MediaQuery.of(context).padding.top + kHeaderHeight;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          kPagePaddingX,
          topSpacing + 16,
          kPagePaddingX,
          112,
        ),
        children: [
          _buildEyebrow("SEUS TÓPICOS"),
          const SizedBox(height: 4),
          _buildH1WithGradient("Estude com ", "flashcards"),
          const SizedBox(height: 4),
          const Text(
            'Crie módulos, adicione cards e marque seu nível de domínio.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // 3.2 Botão CTA "Novo módulo"
          _buildCTAButton(context),
          const SizedBox(height: 20),

          if (store.modules.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: store.modules.map((module) {
                final cardCount = store.cards
                    .where((c) => c.moduleId == module.id)
                    .length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildModuleCard(context, module, cardCount),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEyebrow(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedForeground,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildH1WithGradient(String normalText, String gradientText) {
    return Wrap(
      children: [
        Text(
          normalText,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.foreground,
            letterSpacing: -0.4,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(Offset.zero & bounds.size),
          child: Text(
            gradientText,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _showAddModuleSheet(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.plus, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'Novo módulo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, StudyModule module, int count) {
    final double progress = context.read<StudyStore>().getModuleProgress(
      module.id,
    );
    final int percent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadiusCard),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getCor(module.cor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              LucideIcons.bookOpen,
              size: 20,
              color: _getCor(module.cor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ModuleDetailScreen(module: module),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (module.descricao != null)
                    Text(
                      module.descricao!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '$count cards',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      Text(
                        '$percent% dominado',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // AJUSTE DOS BOTÕES
          Column(
            children: [
              _buildActionButton(
                LucideIcons.pencil,
                AppColors.mutedForeground,
                () => _showAddModuleSheet(context, editing: module),
              ),
              const SizedBox(height: 4),
              _buildActionButton(LucideIcons.trash2, AppColors.red, () {
                _confirmDeletion(
                  context,
                  () => context.read<StudyStore>().deleteModule(module.id),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16, color: color),
        onPressed: onTap,
      ),
    );
  }

  // FUNÇÃO AUXILIAR DE CONFIRMAÇÃO
  void _confirmDeletion(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Excluir módulo?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Isso removerá permanentemente o módulo e todos os seus cards.',
        ),
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

  // ATUALIZAÇÃO DA FUNÇÃO _showAddModuleSheet PARA EDIÇÃO
  void _showAddModuleSheet(BuildContext context, {StudyModule? editing}) {
    final nomeController = TextEditingController(text: editing?.nome);
    final descController = TextEditingController(text: editing?.descricao);
    String corSelecionada = editing?.cor ?? 'blue';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                    editing == null ? 'Novo módulo' : 'Editar módulo',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Nome',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  hintText: 'Ex: Dart...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.input),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descrição (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: 'Breve descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.input),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: ['blue', 'green', 'orange', 'red']
                    .map(
                      (c) => GestureDetector(
                        onTap: () => setModalState(() => corSelecionada = c),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _getCor(c),
                            shape: BoxShape.circle,
                            border: corSelecionada == c
                                ? Border.all(
                                    width: 2,
                                    color: AppColors.foreground,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    )
                    .toList(),
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
                    if (nomeController.text.isNotEmpty) {
                      if (editing == null) {
                        context.read<StudyStore>().createModule(
                          nomeController.text,
                          descController.text,
                          corSelecionada,
                        );
                      } else {
                        context.read<StudyStore>().updateModule(
                          editing.id,
                          nomeController.text,
                          descController.text,
                          corSelecionada,
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
                    editing == null ? 'Criar módulo' : 'Salvar alterações',
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        "Nenhum módulo ainda. Crie o primeiro!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
      ),
    );
  }

  Color _getCor(String corNome) {
    switch (corNome) {
      case 'purple':
        return AppColors.purple; // Agora o VS Code vai reconhecer
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
}
