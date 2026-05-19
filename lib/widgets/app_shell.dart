import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../screens/module_list_screen.dart';
import '../screens/study_index_screen.dart'; // IMPORTANTE: Importe a tela nova
import '../theme/app_colors.dart';
import '../screens/about_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  // Lista de telas principais do App
  final List<Widget> _screens = [
    const ModuleListScreen(), // Aba 0: Módulos
    const StudyIndexScreen(), // Aba 1: Estudar (Onde o conteúdo não aparecia)
    const AboutScreen(), // Aba 2: Sobre
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O IndexedStack mantém o estado das telas (scroll, etc) ao trocar de aba
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.border.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.mutedForeground,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.layers, size: 22),
              label: 'Módulos',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.bookOpen, size: 22),
              label: 'Estudar',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.info, size: 22),
              label: 'Sobre',
            ),
          ],
        ),
      ),
    );
  }
}
