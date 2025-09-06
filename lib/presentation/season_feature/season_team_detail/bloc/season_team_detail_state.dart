import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:equatable/equatable.dart';

/// Trạng thái của màn hình chi tiết đội bóng
class SeasonTeamDetailState extends Equatable {
  /// Trạng thái đang tải dữ liệu
  final bool isLoading;

  /// Trạng thái đang tạo cầu thủ
  final bool isGeneratingPlayers;

  /// Thông báo lỗi (nếu có)
  final String? errorMessage;

  /// Thông tin xếp hạng của đội bóng
  final TeamStandingEntity? teamStanding;

  /// Danh sách cầu thủ của đội bóng
  final List<PlayerSeasonEntity> players;

  /// Constructor
  const SeasonTeamDetailState({
    this.isLoading = false,
    this.isGeneratingPlayers = false,
    this.errorMessage,
    this.teamStanding,
    this.players = const [],
  });

  /// Tạo bản sao với các thuộc tính mới
  SeasonTeamDetailState copyWith({
    bool? isLoading,
    bool? isGeneratingPlayers,
    String? errorMessage,
    TeamStandingEntity? teamStanding,
    List<PlayerSeasonEntity>? players,
  }) {
    return SeasonTeamDetailState(
      isLoading: isLoading ?? this.isLoading,
      isGeneratingPlayers: isGeneratingPlayers ?? this.isGeneratingPlayers,
      errorMessage: errorMessage,
      teamStanding: teamStanding ?? this.teamStanding,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isGeneratingPlayers,
        errorMessage,
        teamStanding,
        players,
      ];
}
