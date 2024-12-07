// Place fonts/ThirstQuestIcons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: ThirstQuestIcons
//      fonts:
//       - asset: fonts/ThirstQuestIcons.ttf
import 'package:flutter/widgets.dart';

class ThirstQuestIcons {
  ThirstQuestIcons._();

  static const String _fontFamily = 'ThirstQuestIcons';

  static const IconData nearest = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData nearestThick = IconData(0xe903, fontFamily: _fontFamily);
  static const IconData thirstQuest = IconData(0xe904, fontFamily: _fontFamily);
  static const IconData bubbler = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData bubblerReflection = IconData(0xe901, fontFamily: _fontFamily);
}
