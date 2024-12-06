import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/utils/route_observer_provider.dart';
import 'package:thirst_quest/widgets/loading.dart';

void main() async {
  DI.configure();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RouteObserver<MaterialPageRoute> routeObserver = RouteObserver<MaterialPageRoute>();

  MyApp({super.key});

  Future _checkAutoLogin(BuildContext context) async {
    final authService = DI.get<AuthService>();
    final state = Provider.of<GlobalState>(context, listen: false);

    authService.checkLoginAndExtend(state);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GlobalState(),
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
              home: FutureBuilder(
                future: _checkAutoLogin(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  }

                  return const MyHomePage();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
