import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';

class MatchModel {
  int? id;
  int? roundId;
  DateTime? matchDate;
  int? homeTeamId;
  int? awayTeamId;
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
    this.homeTeamId,
    this.awayTeamId,
    this.homeColor,
    this.awayColor,
    this.attendance,
    this.homePoints,
    this.awayPoints,
    this.homeFouls,
    this.awayFouls,
  });

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      roundId: roundId,
      matchDate: matchDate,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
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
