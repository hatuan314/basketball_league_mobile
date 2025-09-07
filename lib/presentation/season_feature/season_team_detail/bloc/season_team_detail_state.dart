import 'package:baseketball_league_mobile/domain/entities/player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:equatable/equatable.dart';

enum SeasonTeamDetailStatus { loading, loaded, error }

/// Trạng thái của màn hình chi tiết đội bóng
class SeasonTeamDetailState extends Equatable {
  /// Trạng thái đang tải dữ liệu
  final SeasonTeamDetailStatus status;

  /// Trạng thái đang tạo cầu thủ
  final bool isGeneratingPlayers;

  /// Thông báo lỗi (nếu có)
  final String? errorMessage;

  /// Thông tin xếp hạng của đội bóng
  final TeamStandingEntity? teamStanding;

  /// Danh sách cầu thủ của đội bóng
  final List<PlayerDetailEntity> players;

  /// Constructor
  const SeasonTeamDetailState({
    this.status = SeasonTeamDetailStatus.loading,
    this.isGeneratingPlayers = false,
    this.errorMessage,
    this.teamStanding,
    this.players = const [],
  });

  /// Tạo bản sao với các thuộc tính mới
  SeasonTeamDetailState copyWith({
    SeasonTeamDetailStatus? status,
    bool? isGeneratingPlayers,
    String? errorMessage,
    TeamStandingEntity? teamStanding,
    List<PlayerDetailEntity>? players,
  }) {
    return SeasonTeamDetailState(
      status: status ?? this.status,
      isGeneratingPlayers: isGeneratingPlayers ?? this.isGeneratingPlayers,
      errorMessage: errorMessage,
      teamStanding: teamStanding ?? this.teamStanding,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isGeneratingPlayers,
    errorMessage,
    teamStanding,
    players,
  ];
}
