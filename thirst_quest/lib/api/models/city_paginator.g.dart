// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_paginator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityPaginator _$CityPaginatorFromJson(Map<String, dynamic> json) =>
    CityPaginator(
      totalResultsCount: (json['totalResultsCount'] as num).toInt(),
      geonames: (json['geonames'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CityPaginatorToJson(CityPaginator instance) =>
    <String, dynamic>{
      'totalResultsCount': instance.totalResultsCount,
      'geonames': instance.geonames,
    };
