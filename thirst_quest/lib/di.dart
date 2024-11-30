import 'package:get_it/get_it.dart';
import 'package:thirst_quest/api/api_client.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';

class DI {
  static T get<T extends Object>() => GetIt.instance.get<T>();

  static GetIt getIt = GetIt.instance;

  static void configure() {
    getIt.registerLazySingleton(() => ApiClient());
    getIt.registerLazySingleton(
        () => AuthService(apiClient: getIt<ApiClient>()));
    getIt.registerLazySingleton(() => WaterBubblerService(
        apiClient: getIt<ApiClient>(), authService: getIt<AuthService>()));
  }
}
