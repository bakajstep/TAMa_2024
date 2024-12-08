import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/main_screen.dart';
import 'package:thirst_quest/screens/screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/utils/route_observer_provider.dart';

void main() async {
  DI.configure();

  WidgetsFlutterBinding.ensureInitialized();
  final GlobalState globalState = GlobalState();
  final authService = DI.get<AuthService>();
  await authService.checkLoginAndExtend(globalState);

  runApp(MyApp(globalState: globalState));
}

class MyApp extends StatelessWidget {
  final RouteObserver<MaterialPageRoute> routeObserver = RouteObserver<MaterialPageRoute>();
  final GlobalState globalState;

  MyApp({required this.globalState, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => globalState,
      child: Consumer<GlobalState>(
        builder: (context, globalState, child) {
          return RouteObserverProvider(
            routeObserver: routeObserver,
            child: MaterialApp(
              title: constants.appName,
              navigatorObservers: [routeObserver],
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 22, 98, 160)),
                useMaterial3: true,
              ),
              home: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}
