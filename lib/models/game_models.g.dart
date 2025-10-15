// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      backgroundImage: json['background_image'] as String?,
      released: json['released'] as String?,
      rating: (json['rating'] as num).toDouble(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => GameGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description_raw'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'background_image': instance.backgroundImage,
      'released': instance.released,
      'rating': instance.rating,
      'genres': instance.genres,
      'description_raw': instance.description,
    };

GameGenre _$GameGenreFromJson(Map<String, dynamic> json) => GameGenre(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GameGenreToJson(GameGenre instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
