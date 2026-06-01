import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_header.dart';

class AboutScreen extends StatelessWidget {
  //tela de informações sobre o aplicativo, onde os usuários podem encontrar detalhes sobre o desenvolvedor, o contexto acadêmico do projeto e as funcionalidades oferecidas pelo Studycards. A tela é projetada para ser informativa e visualmente consistente com o restante do aplicativo, utilizando os mesmos tokens de design e seguindo as especificações tipográficas definidas no design system.
  const AboutScreen({super.key});

  @override //sobrescreve o método build para construir a interface da tela de informações. Ele utiliza um Scaffold para estruturar a tela, com um CustomHeader como appBar e um ListView como corpo para permitir a rolagem do conteúdo. O conteúdo é organizado em blocos de texto e cartões informativos, seguindo as especificações de espaçamento e estilo definidas no design system, garantindo uma experiência de usuário consistente e agradável.
  Widget build(BuildContext context) {
    // Medidas de espaçamento idênticas às das telas Home e Estudar para consistência Pixel Perfect
    final double topSpacing = MediaQuery.of(context).padding.top + 60.0;

    return Scaffold(
      //estrutura básica da tela, utilizando um Scaffold para fornecer a estrutura visual e funcional necessária para a tela de informações. O Scaffold inclui um CustomHeader como appBar, que é um componente personalizado para o cabeçalho da tela, e um ListView como corpo para permitir a rolagem do conteúdo informativo. O backgroundColor é definido usando uma cor do tema para garantir consistência visual com o restante do aplicativo.
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
    //método auxiliar para construir os títulos de seções internas do cartão informativo, combinando um ícone e um rótulo de texto. Ele recebe um ícone e um rótulo como parâmetros e retorna um widget Row que exibe o ícone ao lado do texto, estilizado de acordo com as especificações do design system para garantir consistência visual.
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
