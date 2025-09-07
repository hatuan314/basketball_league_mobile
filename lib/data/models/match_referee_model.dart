import 'dart:convert';

import 'package:baseketball_league_mobile/common/enums.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_entity.dart';
import 'package:postgres/postgres.dart';

/// Model đại diện cho thông tin trọng tài trong một trận đấu
class MatchRefereeModel {
  /// ID của bản ghi match_referee
  int? id;

  /// ID của trận đấu
  int? matchId;

  /// ID của trọng tài
  int? refereeId;

  /// Loại trọng tài (chính, phụ, bàn)
  String? role;

  /// Constructor
  MatchRefereeModel({this.id, this.matchId, this.refereeId, this.role});

  factory MatchRefereeModel.fromRow(dynamic row) {
    String role;
    if (row[3] is UndecodedBytes) {
      role = utf8.decode(row[3].bytes);
    } else {
      role = row[3] as String;
    }
    return MatchRefereeModel(
      id: row[0] as int,
      matchId: row[1] as int,
      refereeId: row[2] as int,
      role: role,
    );
  }

  /// Chuyển đổi từ entity sang model
  factory MatchRefereeModel.fromEntity(MatchRefereeEntity entity) {
    return MatchRefereeModel(
      id: entity.id,
      matchId: entity.matchId,
      refereeId: entity.refereeId,
      role: entity.role?.toCode(),
    );
  }

  /// Chuyển đổi từ model sang entity
  MatchRefereeEntity toEntity() {
    return MatchRefereeEntity(
      id: id,
      matchId: matchId,
      refereeId: refereeId,
      role: RefereeType.fromString(role ?? ''),
    );
  }
}
