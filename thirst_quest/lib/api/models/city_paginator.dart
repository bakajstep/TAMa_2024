import 'package:json_annotation/json_annotation.dart';
import 'package:thirst_quest/api/models/city.dart';

part 'city_paginator.g.dart';

@JsonSerializable()
class CityPaginator {
  final int totalResultsCount;
  final List<City> geonames;

  CityPaginator({
    required this.totalResultsCount,
    required this.geonames,
  });

  factory CityPaginator.fromJson(Map<String, dynamic> json) => _$CityPaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$CityPaginatorToJson(this);
}
