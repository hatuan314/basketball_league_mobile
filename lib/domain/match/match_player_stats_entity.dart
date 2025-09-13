/// Entity để lưu trữ thống kê cầu thủ trong trận đấu
class MatchPlayerStatsEntity {
  /// ID của bản ghi thống kê
  int? id;

  /// ID của cầu thủ
  int? matchPlayerId;

  /// Điểm số
  int? points;

  /// Số lỗi
  int? fouls;

  /// Constructor
  MatchPlayerStatsEntity({
    this.id,
    this.matchPlayerId,
    this.points,
    this.fouls,
  });

  /// Tạo bản sao với các giá trị mới
  MatchPlayerStatsEntity copyWith({
    int? id,
    int? matchPlayerId,
    int? points,
    int? fouls,
  }) {
    return MatchPlayerStatsEntity(
      id: id ?? this.id,
      matchPlayerId: matchPlayerId ?? this.matchPlayerId,
      points: points ?? this.points,
      fouls: fouls ?? this.fouls,
    );
  }
}
