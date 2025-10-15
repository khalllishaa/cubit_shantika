import 'package:cubit_shantika/models/game_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_response.g.dart';

@JsonSerializable()
class GamesResponse {
  /// Total count games
  final int count;

  /// Next page URL (null kalau sudah halaman terakhir)
  final String? next;

  /// Previous page URL
  final String? previous;

  /// List games
  final List<GameModel> results;

  GamesResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory GamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GamesResponseToJson(this);

  /// Helper untuk cek apakah ada halaman berikutnya
  bool get hasNext => next != null;

  /// Helper untuk cek apakah ada halaman sebelumnya
  bool get hasPrevious => previous != null;
}