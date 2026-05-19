import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/study_store.dart';
import 'widgets/app_shell.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudyStore(),
      child: const StudyCardsApp(),
    ),
  );
}

class StudyCardsApp extends StatelessWidget {
  const StudyCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyCards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.card,
        ),
        fontFamily: 'Inter', // Se você quiser instalar a fonte depois
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
