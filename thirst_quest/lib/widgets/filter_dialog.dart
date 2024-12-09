import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';
import 'package:thirst_quest/states/global_state.dart';

class FilterDialog extends StatefulWidget {
  final bool filterFavorites;
  final int minHappinessLevel;
  final Function(bool, int) onApplyFilters;

  const FilterDialog({
    super.key,
    required this.filterFavorites,
    required this.minHappinessLevel,
    required this.onApplyFilters,
  });

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  late bool _filterFavorites;
  late int _minHappinessLevel;

  @override
  void initState() {
    super.initState();
    _filterFavorites = widget.filterFavorites;
    _minHappinessLevel = widget.minHappinessLevel;
  }

  IconData _getHappinessIcon(int level) {
    switch (level) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GlobalState>();

    return AlertDialog(
      title: const Text('Map filter',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Favorites Only:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            value: _filterFavorites,
            onChanged: state.user.isLoggedIn
                ? (bool value) {
                    setState(() {
                      _filterFavorites = value;
                    });
                  }
                : null,
          ),
          if (!state.user.isLoggedIn)
            Text('You need to be logged in to use this feature.',
                style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          const Text('Minimum Happiness Level:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int level = index + 1;
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1, // Keep the icon square
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: IconButton(
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      icon: Icon(_getHappinessIcon(level),
                          color: getColorByLevel(_minHappinessLevel >= level ? level : 0)),
                      onPressed: () {
                        setState(() {
                          _minHappinessLevel = level;
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Apply filters and close the dialog
            widget.onApplyFilters(_filterFavorites, _minHappinessLevel);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
