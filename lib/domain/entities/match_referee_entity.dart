import 'package:baseketball_league_mobile/common/enums.dart';

class MatchRefereeEntity {
  int? id;
  int? matchId;
  int? refereeId;
  RefereeType? type;

  MatchRefereeEntity({this.id, this.matchId, this.refereeId, this.type});
}
