import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';

class MatchModel {
  int? id;
  int? roundId;
  DateTime? matchDate;
  int? homeSeasonTeamId;
  int? awaySeasonTeamId;
  String? homeColor;
  String? awayColor;
  int? attendance;
  int? homePoints;
  int? awayPoints;
  int? homeFouls;
  int? awayFouls;

  MatchModel({
    this.id,
    this.roundId,
    this.matchDate,
    this.homeSeasonTeamId,
    this.awaySeasonTeamId,
    this.homeColor,
    this.awayColor,
    this.attendance,
    this.homePoints,
    this.awayPoints,
    this.homeFouls,
    this.awayFouls,
  });

  MatchModel.fromPostgres(List<dynamic> row) {
    id = row[0] as int;
    roundId = row[1] as int;
    matchDate = row[2] as DateTime;
    homeSeasonTeamId = row[3] as int;
    awaySeasonTeamId = row[4] as int;
    homeColor = row[5] as String;
    awayColor = row[6] as String;
    attendance = row[7] as int;
    homePoints = row[8] as int;
    awayPoints = row[9] as int;
    homeFouls = row[10] as int;
    awayFouls = row[11] as int;
  }

  MatchModel.fromEntity(MatchEntity row) {
    id = row.id;
    roundId = row.roundId;
    matchDate = row.matchDate;
    homeSeasonTeamId = row.homeSeasonTeamId;
    awaySeasonTeamId = row.awaySeasonTeamId;
    homeColor = row.homeColor;
    awayColor = row.awayColor;
    attendance = row.attendance;
    homePoints = row.homePoints;
    awayPoints = row.awayPoints;
    homeFouls = row.homeFouls;
    awayFouls = row.awayFouls;
  }

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      roundId: roundId,
      matchDate: matchDate,
      homeSeasonTeamId: homeSeasonTeamId,
      awaySeasonTeamId: awaySeasonTeamId,
      homeColor: homeColor,
      awayColor: awayColor,
      attendance: attendance,
      homePoints: homePoints,
      awayPoints: awayPoints,
      homeFouls: homeFouls,
      awayFouls: awayFouls,
    );
  }
}
