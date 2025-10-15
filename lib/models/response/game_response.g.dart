// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamesResponse _$GamesResponseFromJson(Map<String, dynamic> json) =>
    GamesResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => GameModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GamesResponseToJson(GamesResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
