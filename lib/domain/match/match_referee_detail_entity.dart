import 'package:baseketball_league_mobile/common/enums.dart';

class MatchRefereeDetailEntity {
  int? matchRefereeId;
  int? matchId;
  DateTime? matchDate;
  int? roundId;
  int? roundNo;
  int? seasonId;
  String? seasonName;
  int? refereeId;
  String? refereeName;
  RefereeType? role;
  int? feePerMatch;

  MatchRefereeDetailEntity({
    this.matchRefereeId,
    this.matchId,
    this.matchDate,
    this.roundId,
    this.roundNo,
    this.seasonId,
    this.seasonName,
    this.refereeId,
    this.refereeName,
    this.role,
    this.feePerMatch,
  });
}
