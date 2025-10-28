import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'presentation/app_entry.dart';
import 'presentation/state/manga_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeController),
        ChangeNotifierProvider(create: (_) => MangaStore()..fetchHome()),
      ],
      child: const _Root(),
    ),
  );
}

class _Root extends StatelessWidget {
  const _Root({super.key});

  @override
  Widget build(BuildContext context) {
    final neon = context.watch<ThemeController>().neon;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(neon: neon),
      home: const AppEntry(),
    );
  }
}