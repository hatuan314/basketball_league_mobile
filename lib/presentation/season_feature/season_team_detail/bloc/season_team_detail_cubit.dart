import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_season_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý trạng thái của màn hình chi tiết đội bóng
class SeasonTeamDetailCubit extends Cubit<SeasonTeamDetailState> {
  final SeasonTeamUseCase _seasonTeamUseCase;
  final PlayerSeasonUsecase _playerSeasonUsecase;

  late SeasonTeamEntity _seasonTeam;

  /// Constructor
  SeasonTeamDetailCubit({
    required SeasonTeamUseCase seasonTeamUseCase,
    required PlayerSeasonUsecase playerSeasonUsecase,
  }) : _seasonTeamUseCase = seasonTeamUseCase,
       _playerSeasonUsecase = playerSeasonUsecase,
       super(const SeasonTeamDetailState());

  /// Lấy thông tin chi tiết của đội bóng
  Future<void> loadTeamDetail(int teamId, int seasonId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Lấy thông tin xếp hạng của đội bóng
      final teamStandingsResult = await _seasonTeamUseCase.getTeamStandings(
        seasonId: seasonId,
      );

      final seasonTeamResult = await _seasonTeamUseCase
          .getSeasonTeamBySeasonAndTeam(teamId: teamId, seasonId: seasonId);
      seasonTeamResult.fold(
        (exception) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage:
                  'Lỗi khi lấy thông tin đội bóng: ${exception.toString()}',
            ),
          );
        },
        (seasonTeam) {
          _seasonTeam = seasonTeam!;
        },
      );

      await teamStandingsResult.fold(
        (exception) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage:
                  'Lỗi khi lấy thông tin xếp hạng: ${exception.toString()}',
            ),
          );
        },
        (teamStandings) async {
          // Tìm đội bóng trong danh sách xếp hạng
          final teamStanding = teamStandings.firstWhere(
            (standing) => standing.teamId == teamId,
            orElse: () => throw Exception('Không tìm thấy thông tin đội bóng'),
          );

          // Lấy danh sách cầu thủ của đội bóng
          final playersResult = await _playerSeasonUsecase.getPlayerSeasons(
            seasonTeamId: _seasonTeam.id,
          );

          playersResult.fold(
            (exception) {
              emit(
                state.copyWith(
                  isLoading: false,
                  teamStanding: teamStanding,
                  errorMessage:
                      'Lỗi khi lấy danh sách cầu thủ: ${exception.toString()}',
                ),
              );
            },
            (players) {
              emit(
                state.copyWith(
                  isLoading: false,
                  teamStanding: teamStanding,
                  players: players,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  /// Tạo danh sách cầu thủ tự động cho đội bóng
  Future<void> generatePlayersForTeam(int teamId, int seasonId) async {
    emit(state.copyWith(isGeneratingPlayers: true, errorMessage: null));

    try {
      // Gọi repository để tạo cầu thủ tự động
      final result = await _playerSeasonUsecase.generatePlayerSeasons(
        teamId: teamId,
        seasonId: seasonId,
        seasonTeamId: _seasonTeam.id!,
      );

      result.fold(
        (exception) {
          emit(
            state.copyWith(
              isGeneratingPlayers: false,
              errorMessage: 'Lỗi khi tạo cầu thủ: ${exception.toString()}',
            ),
          );
        },
        (players) {
          emit(state.copyWith(isGeneratingPlayers: false, players: players));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isGeneratingPlayers: false,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }
}
