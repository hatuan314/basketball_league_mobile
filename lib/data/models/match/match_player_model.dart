import 'package:baseketball_league_mobile/domain/match/match_player_entity.dart';

class MatchPlayerModel {
  int? id;
  int? matchId;
  String? playerSeasonId;
  int? fouls;
  int? points;

  MatchPlayerModel({
    this.id,
    this.matchId,
    this.playerSeasonId,
    this.fouls,
    this.points,
  });

  factory MatchPlayerModel.fromPostgres(List<dynamic> row) {
    return MatchPlayerModel(
      id: row[0] as int,
      matchId: row[1] as int,
      playerSeasonId: row[2] as String,
    );
  }

  factory MatchPlayerModel.fromEntity(MatchPlayerEntity entity) {
    return MatchPlayerModel(
      id: entity.id,
      matchId: entity.matchId,
      playerSeasonId: entity.playerSeasonId,
      fouls: entity.fouls,
      points: entity.points,
    );
  }

  MatchPlayerEntity toEntity() {
    return MatchPlayerEntity(
      id: id,
      matchId: matchId,
      playerSeasonId: playerSeasonId,
      fouls: fouls,
      points: points,
    );
  }
}
