import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeader({super.key});

  @override
  // Altura total: 12px (cima) + 12px (baixo) + 32px (ícone) = ~56px + Barra de Status
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    // Pegamos a altura da barra de status (relógio/bateria)
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ), // backdrop-filter: blur(8px)
        child: Container(
          // O container precisa cobrir a área segura + a altura do header
          padding: EdgeInsets.only(top: topPadding),
          decoration: BoxDecoration(
            // background com 85% opacity conforme seção 2 da Spec
            color: AppColors.background.withValues(alpha: 0.85),
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.6), // color-mix 60%
                width: 1,
              ),
            ),
          ),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 2.1 Logo (Esquerda)
                Row(
                  children: [
                    // Quadrado de marca 32x32
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12), // radius 12px
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.layers,
                        size: 16,
                        color: AppColors.primaryForeground,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Studycards',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600, // 600 conforme Spec
                        color: AppColors.foreground,
                        letterSpacing: -0.4, // tracking -0.025em
                      ),
                    ),
                  ],
                ),

                // 2.2 Botão de tema (Direita) 36x36
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    LucideIcons.moon,
                    size: 16,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
