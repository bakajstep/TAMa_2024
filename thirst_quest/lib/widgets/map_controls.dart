import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onCenterButtonPressed;

  const MapControls({super.key, required this.onCenterButtonPressed});

  @override
  Widget build(BuildContext context) {
    return
        // Other widgets...
        Positioned(
      bottom: 20,
      left: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46, // Match FloatingActionButton size
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[700]?.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                // Action for the first button
              },
              icon: Icon(
                Icons.account_circle,
                size: 30,
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14), // Spacing between buttons
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[700]?.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onCenterButtonPressed,
              icon: Icon(
                Icons.navigation,
                size: 30,
              ),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14), // Spacing between buttons
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[700]?.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white, size: 30),
              color: Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                // Perform action based on selected option
                if (value == 'Filter map') {
                  // Action for Filter map
                } else if (value == 'New source') {
                  // Action for New source
                } else if (value == 'Option 3') {
                  // Action for Option 3
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Filter map',
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Filter map', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'New source',
                  child: Row(
                    children: [
                      Icon(Icons.water_drop, color: Colors.white),
                      SizedBox(width: 10),
                      Text('New source', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Option 3',
                  child: Row(
                    children: [
                      Icon(Icons.help, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Option 3', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
