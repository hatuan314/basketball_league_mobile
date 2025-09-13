import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:equatable/equatable.dart';

/// Trạng thái của màn hình bảng xếp hạng
class TeamStandingState extends Equatable {
  /// Danh sách đội bóng trong bảng xếp hạng
  final List<TeamStandingEntity> teamStandings;

  /// Trạng thái loading
  final bool isLoading;

  /// Thông báo lỗi nếu có
  final String? errorMessage;

  /// ID của mùa giải đang hiển thị
  final int? seasonId;

  /// Tên của mùa giải đang hiển thị
  final String? seasonName;

  const TeamStandingState({
    this.teamStandings = const [],
    this.isLoading = false,
    this.errorMessage,
    this.seasonId,
    this.seasonName,
  });

  /// Tạo bản sao của state với các thuộc tính có thể được cập nhật
  TeamStandingState copyWith({
    List<TeamStandingEntity>? teamStandings,
    bool? isLoading,
    String? errorMessage,
    int? seasonId,
    String? seasonName,
  }) {
    return TeamStandingState(
      teamStandings: teamStandings ?? this.teamStandings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      seasonId: seasonId ?? this.seasonId,
      seasonName: seasonName ?? this.seasonName,
    );
  }

  @override
  List<Object?> get props => [
    teamStandings,
    isLoading,
    errorMessage,
    seasonId,
    seasonName,
  ];
}
