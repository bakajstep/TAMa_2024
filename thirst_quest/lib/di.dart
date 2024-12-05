import 'package:get_it/get_it.dart';
import 'package:thirst_quest/api/geo_names_api_client.dart';
import 'package:thirst_quest/api/thirst_quest_api_client.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/services/geo_names_service.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/utils/cache.dart';

class DI {
  static T get<T extends Object>() => GetIt.instance.get<T>();

  static GetIt getIt = GetIt.instance;

  static void configure() {
    getIt.registerLazySingleton(() => ThirstQuestApiClient());
    getIt.registerLazySingleton(() => GeoNamesApiClient());
    getIt.registerLazySingleton(() => Cache());
    getIt.registerLazySingleton(() => AuthService(apiClient: getIt<ThirstQuestApiClient>(), cache: getIt<Cache>()));
    getIt.registerLazySingleton(() => WaterBubblerService(
        apiClient: getIt<ThirstQuestApiClient>(), authService: getIt<AuthService>(), cache: getIt<Cache>()));
    getIt.registerLazySingleton(() => GeoNamesService(apiClient: getIt<GeoNamesApiClient>()));
  }
}
