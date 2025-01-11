import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent background
      child: Center(
          child: CircularProgressIndicator(
        strokeAlign: 6,
        color: Theme.of(context).colorScheme.onPrimary,
      )),
    );
  }
}
