import 'package:json_annotation/json_annotation.dart';

part 'game_models.g.dart';

@JsonSerializable()
class GameModel {
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "background_image")
  final String? backgroundImage;

  @JsonKey(name: "released")
  final String? released;

  @JsonKey(name: "rating")
  final double rating;

  @JsonKey(name: "genres")
  final List<GameGenre>? genres;

  @JsonKey(name: "description_raw")
  final String? description;

  GameModel({
    required this.id,
    required this.name,
    this.backgroundImage,
    this.released,
    required this.rating,
    this.genres,
    this.description,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}

@JsonSerializable()
class GameGenre {
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String name;

  GameGenre({
    required this.id,
    required this.name,
  });

  factory GameGenre.fromJson(Map<String, dynamic> json) =>
      _$GameGenreFromJson(json);

  Map<String, dynamic> toJson() => _$GameGenreToJson(this);
}
