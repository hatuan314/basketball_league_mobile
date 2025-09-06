import 'package:equatable/equatable.dart';

/// Entity class đại diện cho bảng xếp hạng đội bóng
class TeamStandingEntity extends Equatable {
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

  const TeamStandingEntity({
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

  @override
  List<Object?> get props => [
        seasonId,
        seasonName,
        teamId,
        teamName,
        totalPoints,
        totalWins,
        totalLosses,
        totalPointsScored,
        totalPointsConceded,
        pointDifference,
        homeWins,
        awayWins,
        totalFouls,
      ];
}
