import 'package:flutter/material.dart';

class WaterBubblerIcon extends StatefulWidget {
  const WaterBubblerIcon({super.key});

  @override
  WaterBubblerIconState createState() => WaterBubblerIconState();
}

class WaterBubblerIconState extends State<StatefulWidget> {
  Color _iconColor = Colors.indigoAccent;

  @override
  Widget build(BuildContext context){
    return IconButton(
      onPressed: (){
        setState(() {
          _iconColor = Colors.cyanAccent;
        });
      },
      icon: 
        Icon(
          Icons.local_drink,
          color: _iconColor,
          size: 40.0,
        ),
    );
  }
}