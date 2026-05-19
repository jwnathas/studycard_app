import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Medidas de espaçamento idênticas às das telas Home e Estudar para consistência Pixel Perfect
    final double topSpacing = MediaQuery.of(context).padding.top + 60.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(),
      extendBodyBehindAppBar:
          true, // Garante que o efeito blur do cabeçalho funcione
      body: ListView(
        // Margens alinhadas com a UI Spec: 20px laterais, espaçamento superior compensando o Header e 112px base para a BottomNav
        padding: EdgeInsets.fromLTRB(20.0, topSpacing + 16.0, 20.0, 112.0),
        children: [
          // Bloco de Cabeçalho da Seção conforme especificações tipográficas
          const Text(
            "INFORMAÇÕES",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedForeground,
              letterSpacing: 1.2, // tracking-wider
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Sobre o App",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
              letterSpacing: -0.36, // tracking-tight
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Sua plataforma de memorização ativa e flashcards.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 20), // Gap vertical padrão (space-y-5)
          // 1. Card com Informações Acadêmicas e Autoria do Projeto
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16), // rounded-2xl
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(LucideIcons.user, "Desenvolvedor"),
                const SizedBox(height: 8),
                const Text(
                  "Jônathas Batista Silva",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(
                  LucideIcons.graduationCap,
                  "Contexto Acadêmico",
                ),
                const SizedBox(height: 8),
                const Text(
                  "Disciplina: Desenvolvimento para Dispositivos Móveis\n"
                  "Instituição: Instituto Federal de Brasília (IFB)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.foreground,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // space-y-4 entre blocos principais
          // 2. Card com Informações de Funcionalidades do App
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.layers,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Funcionalidades do Studycards",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "• Organização por Módulos Temáticos de Estudo.\n"
                  "• Criação, edição e exclusão personalizada de Flashcards.\n"
                  "• Sessão de estudos prática com feedback de memorização.\n"
                  "• Acompanhamento do progresso em tempo real.\n"
                  "• Interface Pixel-Perfect baseada em Design Tokens modernos.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedForeground,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir os títulos de seções internas do cartão informativo
  Widget _buildSectionTitle(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mutedForeground),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedForeground,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
