import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  final String? errorMessage;

  const FormError({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    final errorColor = Theme.of(context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.error, color: errorColor),
          const SizedBox(width: 10),
          Flexible(
              child: Text(errorMessage!,
                  style: TextStyle(color: errorColor),
                  overflow: TextOverflow.visible)),
        ],
      ),
    );
  }
}
