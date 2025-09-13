import 'package:baseketball_league_mobile/domain/match/match_player_stats_entity.dart';

/// Model để lưu trữ thống kê cầu thủ trong trận đấu
class MatchPlayerStatsModel {
  /// ID của bản ghi thống kê
  int? id;

  /// ID của cầu thủ
  int? matchPlayerId;

  /// Điểm số
  int? points;

  /// Số lỗi
  int? fouls;

  /// Constructor
  MatchPlayerStatsModel({this.id, this.matchPlayerId, this.points, this.fouls});

  /// Chuyển đổi từ model sang entity
  MatchPlayerStatsEntity toEntity() {
    return MatchPlayerStatsEntity(
      id: id,
      matchPlayerId: matchPlayerId,
      points: points,
      fouls: fouls,
    );
  }

  /// Chuyển đổi từ entity sang model
  static MatchPlayerStatsModel fromEntity(MatchPlayerStatsEntity entity) {
    return MatchPlayerStatsModel(
      id: entity.id,
      matchPlayerId: entity.matchPlayerId,
      points: entity.points,
      fouls: entity.fouls,
    );
  }

  /// Chuyển đổi từ kết quả truy vấn PostgreSQL sang model
  factory MatchPlayerStatsModel.fromPostgres(List<dynamic> row) {
    return MatchPlayerStatsModel(
      id: row[0] as int,
      matchPlayerId: row[1] as int,
      points: row[2] as int,
      fouls: row[3] as int,
    );
  }

  /// Chuyển đổi model thành Map để lưu vào database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'match_player_id': matchPlayerId,
      'points': points,
      'fouls': fouls,
    };
  }
}
