import 'package:thirst_quest/states/main_screen_action.dart';

class MainActionController {
  final List<MainScreenAction> _actions = <MainScreenAction>[];

  void pushAction(MainScreenAction action) {
    if (action == MainScreenAction.none) {
      _actions.clear();
      return;
    }

    if (currentAction == action) {
      return;
    }

    _actions.add(action);
  }

  void popAction() {
    if (_actions.isEmpty) {
      return;
    }

    _actions.removeLast();
  }

  MainScreenAction get currentAction =>
      _actions.isEmpty ? MainScreenAction.none : _actions.last;
}
