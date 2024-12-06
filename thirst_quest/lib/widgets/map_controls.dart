import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/screens/add_bubbler.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/screens/profile_screen.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;

class MapControls extends StatelessWidget {
  final VoidCallback onCenterButtonPressed;
  final double bottomOffset;
  final bool visible;

  const MapControls({super.key, required this.onCenterButtonPressed, this.bottomOffset = 0.0, this.visible = true});

  void _goToProfile(BuildContext context) {
    final state = Provider.of<GlobalState>(context, listen: false);
    if (!state.user.isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _goToCreateBubbler(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    final state = Provider.of<BubblerMapState>(context, listen: false);

    if (!globalState.user.isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    
    final position = state.mapController.camera.center;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBubblerMapScreen(location: position)),
    );

  void _filterFavorites(BuildContext context) {
    final state = Provider.of<GlobalState>(context, listen: false);
    if (!state.user.isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }

    final bubblerState = Provider.of<BubblerMapState>(context, listen: false);
    bubblerState.toggleFavoritesFilter();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: constants.longAnimationDuration),
        curve: Curves.easeInOut,
        left: 20,
        bottom: 20 + bottomOffset,
        child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: constants.shortAnimationDuration),
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
                    onPressed: () => _goToProfile(context),
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
                        _filterFavorites(context);
                      } else if (value == 'New source') {
                        _goToCreateBubbler(context);
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
                    ],
                  ),
                ),
              ],
            )));
  }
}
