import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';

/// Model class đại diện cho bảng xếp hạng đội bóng
class TeamStandingModel {
  /// ID của mùa giải
  final int? seasonId;
  
  /// Tên mùa giải
  final String? seasonName;
  
  /// ID của đội bóng
  final int? teamId;
  
  /// Tên đội bóng
  final String? teamName;
  
  /// Tổng số điểm
  final int? totalPoints;
  
  /// Tổng số trận thắng
  final int? totalWins;
  
  /// Tổng số trận thua
  final int? totalLosses;
  
  /// Tổng số điểm ghi được
  final int? totalPointsScored;
  
  /// Tổng số điểm bị ghi
  final int? totalPointsConceded;
  
  /// Hiệu số điểm (điểm ghi được - điểm bị ghi)
  final int? pointDifference;
  
  /// Số trận thắng sân nhà
  final int? homeWins;
  
  /// Số trận thắng sân khách
  final int? awayWins;
  
  /// Tổng số lỗi
  final int? totalFouls;

  TeamStandingModel({
    this.seasonId,
    this.seasonName,
    this.teamId,
    this.teamName,
    this.totalPoints,
    this.totalWins,
    this.totalLosses,
    this.totalPointsScored,
    this.totalPointsConceded,
    this.pointDifference,
    this.homeWins,
    this.awayWins,
    this.totalFouls,
  });

  /// Tạo model từ dữ liệu row trả về từ database
  factory TeamStandingModel.fromRow(List<dynamic> row) {
    return TeamStandingModel(
      seasonId: row[0],
      seasonName: row[1],
      teamId: row[2],
      teamName: row[3],
      totalPoints: row[4],
      totalWins: row[5],
      totalLosses: row[6],
      totalPointsScored: row[7],
      totalPointsConceded: row[8],
      pointDifference: row[9],
      homeWins: row[10],
      awayWins: row[11],
      totalFouls: row[12],
    );
  }

  /// Tạo model từ entity
  factory TeamStandingModel.fromEntity(TeamStandingEntity entity) {
    return TeamStandingModel(
      seasonId: entity.seasonId,
      seasonName: entity.seasonName,
      teamId: entity.teamId,
      teamName: entity.teamName,
      totalPoints: entity.totalPoints,
      totalWins: entity.totalWins,
      totalLosses: entity.totalLosses,
      totalPointsScored: entity.totalPointsScored,
      totalPointsConceded: entity.totalPointsConceded,
      pointDifference: entity.pointDifference,
      homeWins: entity.homeWins,
      awayWins: entity.awayWins,
      totalFouls: entity.totalFouls,
    );
  }

  /// Chuyển đổi model thành entity
  TeamStandingEntity toEntity() {
    return TeamStandingEntity(
      seasonId: seasonId,
      seasonName: seasonName,
      teamId: teamId,
      teamName: teamName,
      totalPoints: totalPoints,
      totalWins: totalWins,
      totalLosses: totalLosses,
      totalPointsScored: totalPointsScored,
      totalPointsConceded: totalPointsConceded,
      pointDifference: pointDifference,
      homeWins: homeWins,
      awayWins: awayWins,
      totalFouls: totalFouls,
    );
  }

  /// Tạo bản sao của model với các thuộc tính có thể được cập nhật
  TeamStandingModel copyWith({
    int? seasonId,
    String? seasonName,
    int? teamId,
    String? teamName,
    int? totalPoints,
    int? totalWins,
    int? totalLosses,
    int? totalPointsScored,
    int? totalPointsConceded,
    int? pointDifference,
    int? homeWins,
    int? awayWins,
    int? totalFouls,
  }) {
    return TeamStandingModel(
      seasonId: seasonId ?? this.seasonId,
      seasonName: seasonName ?? this.seasonName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      totalPoints: totalPoints ?? this.totalPoints,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      totalPointsScored: totalPointsScored ?? this.totalPointsScored,
      totalPointsConceded: totalPointsConceded ?? this.totalPointsConceded,
      pointDifference: pointDifference ?? this.pointDifference,
      homeWins: homeWins ?? this.homeWins,
      awayWins: awayWins ?? this.awayWins,
      totalFouls: totalFouls ?? this.totalFouls,
    );
  }
}
