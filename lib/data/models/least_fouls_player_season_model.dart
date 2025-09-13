import 'package:baseketball_league_mobile/domain/entities/least_fouls_player_season_entity.dart';

class LeastFoulsPlayerSeasonModel {
  int? seasonId;
  String? seasonName;
  int? playerId;
  String? playerCode;
  String? playerName;
  int? teamId;
  String? teamName;
  int? totalFouls;

  LeastFoulsPlayerSeasonModel({
    this.seasonId,
    this.seasonName,
    this.playerId,
    this.playerCode,
    this.playerName,
    this.teamId,
    this.teamName,
    this.totalFouls,
  });

  factory LeastFoulsPlayerSeasonModel.fromPostgres(List<dynamic> row) {
    return LeastFoulsPlayerSeasonModel(
      seasonId: row[0],
      seasonName: row[1],
      playerId: row[2],
      playerCode: row[3],
      playerName: row[4],
      teamId: row[5],
      teamName: row[6],
      totalFouls: row[7],
    );
  }

  LeastFoulsPlayerSeasonEntity toEntity() {
    return LeastFoulsPlayerSeasonEntity(
      seasonId: seasonId,
      seasonName: seasonName,
      playerId: playerId,
      playerCode: playerCode,
      playerName: playerName,
      teamId: teamId,
      teamName: teamName,
      totalFouls: totalFouls,
    );
  }
}
