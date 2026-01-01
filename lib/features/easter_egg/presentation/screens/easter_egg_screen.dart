import 'package:flutter/material.dart';
import 'package:seasonbox/widgets/loading/boxy_saving_indicator.dart';
import 'package:seasonbox/core/enums/item_type.dart';
import 'package:go_router/go_router.dart';

class EasterEggScreen extends StatelessWidget {
  const EasterEggScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easter Egg 🐣'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BoxySavingIndicator(
              size: 250,
              itemType: ItemType.other,
            ),
            const SizedBox(height: 16),
            const Text(
              'You found the hidden boxy!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/premium-congratulations'),
              icon: const Icon(Icons.celebration),
              label: const Text('Preview Premium Celebration'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
