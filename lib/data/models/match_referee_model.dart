import 'package:baseketball_league_mobile/common/enums.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_entity.dart';

class MatchRefereeModel {
  int? id;
  int? matchId;
  int? refereeId;
  String? type;

  MatchRefereeModel({this.id, this.matchId, this.refereeId, this.type});

  MatchRefereeEntity toEntity() {
    return MatchRefereeEntity(
      id: id,
      matchId: matchId,
      refereeId: refereeId,
      type: RefereeType.fromString(type ?? ''),
    );
  }
}
