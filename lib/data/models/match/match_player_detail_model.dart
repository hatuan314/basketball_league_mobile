import 'package:baseketball_league_mobile/domain/match/match_player_detail_entity.dart';

class MatchPlayerDetailModel {
  int? matchPlayerId;
  int? matchId;
  DateTime? matchDatetime;
  int? roundId;
  int? roundNo;
  int? seasonId;
  String? seasonName;
  int? playerId;
  String? playerCode;
  String? playerName;
  int? teamId;
  String? teamName;
  int? shirtNumber;
  int? points;
  int? fouls;

  MatchPlayerDetailModel({
    this.matchPlayerId,
    this.matchId,
    this.matchDatetime,
    this.roundId,
    this.roundNo,
    this.seasonId,
    this.seasonName,
    this.playerId,
    this.playerCode,
    this.playerName,
    this.teamId,
    this.teamName,
    this.shirtNumber,
    this.points,
    this.fouls,
  });

  factory MatchPlayerDetailModel.fromPostgres(List<dynamic> row) {
    return MatchPlayerDetailModel(
      matchPlayerId: row[0] as int?,
      matchId: row[1] as int?,
      matchDatetime: row[2] as DateTime?,
      roundId: row[3] as int?,
      roundNo: row[4] as int?,
      seasonId: row[5] as int?,
      seasonName: row[6] as String?,
      playerId: row[7] as int?,
      playerCode: row[8] as String?,
      playerName: row[9] as String?,
      teamId: row[10] as int?,
      teamName: row[11] as String?,
      shirtNumber: row[12] as int?,
      points: row[13] as int?,
      fouls: row[14] as int?,
    );
  }

  MatchPlayerDetailEntity toEntity() {
    return MatchPlayerDetailEntity(
      matchPlayerId: matchPlayerId,
      matchId: matchId,
      matchDatetime: matchDatetime,
      roundId: roundId,
      roundNo: roundNo,
      seasonId: seasonId,
      seasonName: seasonName,
      playerId: playerId,
      playerCode: playerCode,
      playerName: playerName,
      teamId: teamId,
      teamName: teamName,
      shirtNumber: shirtNumber,
      points: points,
      fouls: fouls,
    );
  }
}
