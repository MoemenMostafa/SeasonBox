import 'package:flutter/material.dart';
import 'package:seasonbox/widgets/loading/boxy_saving_indicator.dart';
import 'package:seasonbox/core/enums/item_type.dart';

class EasterEggScreen extends StatelessWidget {
  const EasterEggScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easter Egg 🐣'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoxySavingIndicator(
              size: 250,
              itemType: ItemType.other,
            ),
            SizedBox(height: 16),
            Text(
              'You found the hidden boxy!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
