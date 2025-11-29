import 'package:flutter/material.dart';

class SeasonBoxAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SeasonBoxAddButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }
}
