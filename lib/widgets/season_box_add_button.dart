import 'package:flutter/material.dart';

class SeasonBoxAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Object? heroTag;

  const SeasonBoxAddButton({
    super.key,
    required this.onPressed,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }
}
