import 'package:flutter/material.dart';
import '../utils/reset_app.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text("Reset All Progress"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text("Reset Progress?"),
                    content: const Text(
                      "This will erase all your grades and progress. This action cannot be undone.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                        child: const Text("Reset"),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                await resetAppData();

                if (!context.mounted) return;

                // 🔥 HARD RESTART APP
                RestartWidget.restartApp(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
