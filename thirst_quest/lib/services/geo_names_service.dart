import 'package:thirst_quest/api/geo_names_api_client.dart';
import 'package:thirst_quest/api/models/city.dart';

class GeoNamesService {
  final GeoNamesApiClient apiClient;

  GeoNamesService({required this.apiClient});

  Future<List<City>> getCitiesByPrefix(String prefix) async {
    final paginator = await apiClient.getCitiesByPrefix(prefix);

    return paginator.geonames;
  }
}
