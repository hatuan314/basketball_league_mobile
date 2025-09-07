import 'package:baseketball_league_mobile/common/enums.dart';

/// Entity đại diện cho thông tin trọng tài trong một trận đấu
class MatchRefereeEntity {
  /// ID của bản ghi match_referee (format: M{match_id}_R{referee_id})
  int? id;

  /// ID của trận đấu
  int? matchId;

  /// ID của trọng tài
  int? refereeId;

  /// Loại trọng tài (chính, phụ, bàn)
  RefereeType? role;

  /// Constructor
  MatchRefereeEntity({this.id, this.matchId, this.refereeId, this.role});
}
