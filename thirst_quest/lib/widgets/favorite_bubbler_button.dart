import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/screens/main_screen.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/states/global_state.dart';

class FavoriteBubblerButton extends StatefulWidget {
  final WaterBubbler waterBubbler;
  final double? size;

  const FavoriteBubblerButton({required this.waterBubbler, this.size, super.key});

  @override
  State<StatefulWidget> createState() => FavoriteBubblerButtonState();
}

class FavoriteBubblerButtonState extends State<FavoriteBubblerButton> {
  final WaterBubblerService waterBubblerService = DI.get<WaterBubblerService>();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.waterBubbler.isFavorite;
  }

  void _onPresed() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await waterBubblerService.toggleFavorite(widget.waterBubbler);
    _isFavorite = widget.waterBubbler.isFavorite;
  }

  void _redirectToLogin() {
    final mapState = context.read<BubblerMapState>();

    ModalRoute.of(context)?.settings.name;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
            onLoginSuccess: MaterialPageRoute(
                builder: (context) => MainScreen(initialPosition: mapState.mapController.camera.center))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();

    // return IconButton(
    //   onPressed: globalState.user.isLoggedIn ? _onPresed : _redirectToLogin,
    //   padding: EdgeInsets.all(5),
    //   iconSize: widget.size != null ? (widget.size! - 10) : null,
    //   icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
    // );

    // return Material(
    //   elevation: 5,
    //   shape: CircleBorder(),
    //   color: Colors.grey[400],
    //   child: SizedBox(
    //     width: widget.size,
    //     height: widget.size,
    //     child: IconButton(
    //       onPressed: globalState.user.isLoggedIn ? _onPresed : _redirectToLogin,
    //       iconSize: widget.size != null ? (widget.size! - 20) : 24,
    //       icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.pinkAccent : Colors.white),
    //     ),
    //   ),
    // );

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400], // Background color
        shape: BoxShape.circle, // Makes the background circular
      ),
      child: IconButton(
        onPressed: globalState.user.isLoggedIn ? _onPresed : _redirectToLogin,
        iconSize: widget.size != null ? (widget.size! - 20) : 24,
        icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.pinkAccent : Colors.white),
      ),
    );
  }
}
