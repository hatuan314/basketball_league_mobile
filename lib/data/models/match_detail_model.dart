import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';

class MatchDetailModel {
  int? matchId;
  DateTime? matchDate;
  int? roundId;
  int? roundNo;
  int? seasonId;
  String? seasonName;
  int? homeTeamId;
  int? awayTeamId;
  String? homeTeamName;
  String? awayTeamName;
  String? homeColor;
  String? awayColor;
  int? homePoints;
  int? awayPoints;
  int? homeFouls;
  int? awayFouls;
  int? attendance;
  int? stadiumId;
  String? stadiumName;
  double? ticketPrice;
  int? winnerTeamId;
  String? winnerTeamName;

  MatchDetailModel({
    this.matchId,
    this.matchDate,
    this.roundId,
    this.roundNo,
    this.seasonId,
    this.seasonName,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeColor,
    this.awayColor,
    this.homePoints,
    this.awayPoints,
    this.homeFouls,
    this.awayFouls,
    this.attendance,
    this.stadiumId,
    this.stadiumName,
    this.ticketPrice,
    this.winnerTeamId,
    this.winnerTeamName,
  });

  factory MatchDetailModel.fromRow(dynamic row) {
    return MatchDetailModel(
      matchId: row[0] as int,
      matchDate: row[1] as DateTime,
      roundId: row[2] as int,
      roundNo: row[3] as int,
      seasonId: row[4] as int,
      seasonName: row[5] as String,
      homeTeamId: row[6] as int,
      awayTeamId: row[7] as int,
      homeTeamName: row[8] as String,
      awayTeamName: row[9] as String,
      homeColor: row[10] as String,
      awayColor: row[11] as String,
      homePoints: row[12] as int,
      awayPoints: row[13] as int,
      homeFouls: row[14] as int,
      awayFouls: row[15] as int,
      attendance: row[16] as int,
      stadiumId: row[17] as int,
      stadiumName: row[18] as String,
      ticketPrice: double.parse(row[19] as String),
      winnerTeamId: row[20] as int?,
      winnerTeamName: row[21] as String?,
    );
  }

  MatchDetailEntity toEntity() {
    return MatchDetailEntity(
      matchId: matchId,
      matchDate: matchDate,
      roundId: roundId,
      roundNo: roundNo,
      seasonId: seasonId,
      seasonName: seasonName,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      homeColor: homeColor,
      awayColor: awayColor,
      homePoints: homePoints,
      awayPoints: awayPoints,
      homeFouls: homeFouls,
      awayFouls: awayFouls,
      attendance: attendance,
      stadiumId: stadiumId,
      stadiumName: stadiumName,
      ticketPrice: ticketPrice,
      winnerTeamId: winnerTeamId,
      winnerTeamName: winnerTeamName,
    );
  }
}
