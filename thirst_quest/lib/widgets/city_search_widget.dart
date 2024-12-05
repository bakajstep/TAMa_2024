import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:thirst_quest/api/models/city.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/geo_names_service.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;

class CitySearchWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final GeoNamesService _geoNamesService = DI.get<GeoNamesService>();
  final Function(City) onCitySelected;

  CitySearchWidget({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<City>(
      debounceDuration: const Duration(milliseconds: 500),
      controller: _searchController,
      builder: (context, controller, focusNode) => SearchBar(
        controller: controller,
        focusNode: focusNode,
        hintText: 'Search...',
        leading: const Padding(padding: EdgeInsets.only(left: 8.0), child: Icon(Icons.search)),
      ),
      emptyBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _searchController.text.length < constants.minCharsForSearch
              ? 'Type at least 2 characters to search.'
              : 'No cities found. Please try again.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.length < constants.minCharsForSearch) return [];

        return await _geoNamesService.getCitiesByPrefix(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name),
        );
      },
      onSelected: (suggestion) {
        _searchController.text = suggestion.name;
        onCitySelected(suggestion);
      },
    );
  }
}
