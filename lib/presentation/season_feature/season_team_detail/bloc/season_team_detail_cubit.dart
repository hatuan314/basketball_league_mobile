import 'package:baseketball_league_mobile/common/app_utils.dart';
import 'package:baseketball_league_mobile/domain/entities/player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/season_team_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_season_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_team_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý trạng thái của màn hình chi tiết đội bóng
class SeasonTeamDetailCubit extends Cubit<SeasonTeamDetailState> {
  final SeasonTeamUseCase _seasonTeamUseCase;
  final PlayerSeasonUsecase _playerSeasonUsecase;

  SeasonTeamEntity? _seasonTeam;

  /// Constructor
  SeasonTeamDetailCubit({
    required SeasonTeamUseCase seasonTeamUseCase,
    required PlayerSeasonUsecase playerSeasonUsecase,
  }) : _seasonTeamUseCase = seasonTeamUseCase,
       _playerSeasonUsecase = playerSeasonUsecase,
       super(const SeasonTeamDetailState());

  /// Lấy thông tin chi tiết của đội bóng
  Future<void> loadTeamDetail(int teamId, int seasonId) async {
    emit(
      state.copyWith(
        status: SeasonTeamDetailStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final loadTeamDetailResult = await Future.wait([
        _getSeasonTeamBySeasonAndTeam(teamId, seasonId),
        _getTeamStanding(teamId, seasonId),
        _getPlayerDetailsBySeasonIdAndTeamId(seasonId, teamId: teamId),
      ]);
      if (loadTeamDetailResult.isNotEmpty) {
        _seasonTeam = loadTeamDetailResult[0] as SeasonTeamEntity?;
        final teamStanding = loadTeamDetailResult[1] as TeamStandingEntity?;
        final players = loadTeamDetailResult[2] as List<PlayerDetailEntity>?;
        if (_seasonTeam == null || teamStanding == null || players == null) {
          emit(
            state.copyWith(
              status: SeasonTeamDetailStatus.error,
              errorMessage: 'Không tìm thấy thông tin đội bóng',
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: SeasonTeamDetailStatus.loaded,
            teamStanding: teamStanding,
            players: players,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SeasonTeamDetailStatus.error,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  Future<TeamStandingEntity?> _getTeamStanding(int teamId, int seasonId) async {
    final teamStandingsResult = await _seasonTeamUseCase.getTeamStandings(
      seasonId: seasonId,
      teamId: teamId,
    );
    return teamStandingsResult.fold(
      (exception) {
        emit(
          state.copyWith(
            status: SeasonTeamDetailStatus.error,
            errorMessage:
                'Lỗi khi lấy thông tin xếp hạng: ${exception.toString()}',
          ),
        );
        return null;
      },
      (teamStandings) {
        if (AppUtils.isNullEmptyList(teamStandings)) {
          emit(
            state.copyWith(
              status: SeasonTeamDetailStatus.error,
              errorMessage: 'Không tìm thấy thông tin đội bóng',
            ),
          );
          return null;
        }
        // Tìm đội bóng trong danh sách xếp hạng
        final teamStanding = teamStandings.first;
        return teamStanding;
      },
    );
  }

  Future<SeasonTeamEntity?> _getSeasonTeamBySeasonAndTeam(
    int teamId,
    int seasonId,
  ) async {
    final result = await _seasonTeamUseCase.getSeasonTeamBySeasonAndTeam(
      teamId: teamId,
      seasonId: seasonId,
    );
    return result.fold((exception) {
      emit(
        state.copyWith(
          status: SeasonTeamDetailStatus.error,
          errorMessage:
              'Lỗi khi lấy thông tin đội bóng: ${exception.toString()}',
        ),
      );
      return null;
    }, (seasonTeam) => seasonTeam);
  }

  /// Tạo danh sách cầu thủ tự động cho đội bóng
  Future<void> generatePlayersForTeam(int teamId, int seasonId) async {
    emit(state.copyWith(isGeneratingPlayers: true, errorMessage: null));

    try {
      // Gọi repository để tạo cầu thủ tự động
      final result = await _playerSeasonUsecase.generatePlayerSeasons(
        teamId: teamId,
        seasonId: seasonId,
        seasonTeamId: _seasonTeam!.id!,
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
        (players) async {
          // Lấy danh sách chi tiết cầu thủ [PlayerDetailEntity]
          final playerDetails = await _getPlayerDetailsBySeasonIdAndTeamId(
            seasonId,
            teamId: teamId,
          );
          emit(
            state.copyWith(
              isGeneratingPlayers: false,
              players: playerDetails ?? [],
            ),
          );
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

  Future<List<PlayerDetailEntity>?> _getPlayerDetailsBySeasonIdAndTeamId(
    int seasonId, {
    int? teamId,
  }) async {
    try {
      final result = await _playerSeasonUsecase
          .getPlayerDetailsBySeasonIdAndTeamId(seasonId, teamId: teamId);
      return result.fold((exception) {
        emit(
          state.copyWith(
            status: SeasonTeamDetailStatus.error,
            errorMessage:
                'Lỗi khi lấy danh sách chi tiết cầu thủ: ${exception.toString()}',
          ),
        );
        return null;
      }, (playerDetails) => playerDetails);
    } catch (e) {
      emit(
        state.copyWith(
          status: SeasonTeamDetailStatus.error,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
      return null;
    }
  }
}
