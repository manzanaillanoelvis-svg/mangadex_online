import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _dontShow = false;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_hidden', _dontShow);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/'); // RootShell via AppEntry
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text("Bienvenido a MangaDex Online",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text("Lee, organiza y descubre nuevos mangas desde tus fuentes favoritas.",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const Spacer(),
            Row(
              children: [
                Checkbox(
                  value: _dontShow,
                  onChanged: (v) => setState(() => _dontShow = v ?? false),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  side: BorderSide(color: accent),
                  activeColor: accent,
                ),
                const Text("No volver a mostrar"),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _finish,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Empezar"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}