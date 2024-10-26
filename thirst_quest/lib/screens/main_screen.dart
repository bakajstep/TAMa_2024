import 'package:flutter/material.dart';
import 'package:thirst_quest/widgets/map.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Second Screen'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(child: LocationMap()),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This is some text below the map.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }
}
