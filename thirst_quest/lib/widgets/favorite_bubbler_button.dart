import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
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
    _isFavorite = widget.waterBubbler.favorite;
  }

  void _onPresed() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await waterBubblerService.toggleFavorite(widget.waterBubbler);
    _isFavorite = widget.waterBubbler.favorite;
  }

  void _redirectToLogin() {
    ModalRoute.of(context)?.settings.name;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(popOnSuccess: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();

    return IconButton(
      key: ValueKey(widget.waterBubbler.id ?? widget.waterBubbler.osmId),
      onPressed: globalState.user.isLoggedIn ? _onPresed : _redirectToLogin,
      padding: EdgeInsets.all(5),
      iconSize: widget.size != null ? (widget.size! - 10) : null,
      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
    );
  }
}
