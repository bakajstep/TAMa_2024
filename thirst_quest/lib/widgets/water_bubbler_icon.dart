import 'package:flutter/material.dart';

class WaterBubblerIcon extends StatefulWidget {
  final bool isCurrent;

  const WaterBubblerIcon({required this.isCurrent, super.key});

  @override
  WaterBubblerIconState createState() => WaterBubblerIconState();
}

class WaterBubblerIconState extends State<WaterBubblerIcon> {
  Color _iconColor = Colors.indigoAccent;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _iconColor = Colors.cyanAccent;
        });
      },
      icon: Icon(
        Icons.local_drink,
        color: widget.isCurrent ? Colors.red : _iconColor,
        size: 40.0,
      ),
    );
  }
}
