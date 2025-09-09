import 'package:baseketball_league_mobile/common/app_utils.dart';
import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_stats_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/service/match_detail_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit để quản lý state của màn hình chi tiết trận đấu
class MatchDetailCubit extends Cubit<MatchDetailState> {
  /// Service để xử lý logic liên quan đến chi tiết trận đấu
  final MatchDetailService _matchDetailService;

  MatchEntity? _match;

  /// Constructor
  MatchDetailCubit({required MatchDetailService matchDetailService})
    : _matchDetailService = matchDetailService,
      super(MatchDetailState.loading());

  /// Thiết lập thông tin ban đầu và tải dữ liệu
  void initial({required int matchId, required int roundId}) async {
    emit(
      state.copyWith(
        matchId: matchId,
        roundId: roundId,
        status: MatchDetailStatus.loading,
      ),
    );
    final results = await Future.wait([
      _loadMatch(matchId),
      _loadMatchDetail(matchId, roundId),
      _loadMatchReferees(matchId),
    ]);
    if (!AppUtils.isNullEmptyList(results) &&
        results[0] != null &&
        results[1] != null &&
        results[2] != null) {
      _match = results[0] as MatchEntity;
      final playersResult = await Future.wait([
        _getTeamPlayersDetailInMatch(matchId, _match!.homeSeasonTeamId!),
        _getTeamPlayersDetailInMatch(matchId, _match!.awaySeasonTeamId!),
      ]);
      if (!AppUtils.isNullEmptyList(playersResult) &&
          playersResult[0] != null &&
          playersResult[1] != null) {
        emit(
          state.copyWith(
            match: results[1] as MatchDetailEntity,
            referees: results[2] as List<MatchRefereeDetailEntity>,
            homeTeamPlayers: playersResult[0] as List<MatchPlayerDetailEntity>,
            awayTeamPlayers: playersResult[1] as List<MatchPlayerDetailEntity>,
            status: MatchDetailStatus.initial,
          ),
        );
      }
    }
  }

  Future<List<MatchPlayerDetailEntity>?> _getTeamPlayersDetailInMatch(
    int matchId,
    int teamId,
  ) async {
    try {
      final result = await _matchDetailService.getTeamPlayerDetailsInMatch(
        matchId,
        teamId,
      );

      return result.fold(
        (error) {
          emit(
            state.copyWith(
              status: MatchDetailStatus.failure,
              errorMessage: error.toString(),
            ),
          );
          return null;
        },
        (players) {
          return players;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.failure,
          errorMessage: 'Lỗi khi tải thông tin cầu thủ trong trận đấu: $e',
        ),
      );
      return [];
    }
  }

  Future<MatchEntity?> _loadMatch(int matchId) async {
    try {
      final result = await _matchDetailService.getMatchById(matchId);

      return result.fold(
        (error) {
          emit(
            state.copyWith(
              status: MatchDetailStatus.failure,
              errorMessage: error.toString(),
            ),
          );
          return null;
        },
        (match) {
          return match;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.failure,
          errorMessage: 'Lỗi khi tải thông tin trận đấu: $e',
        ),
      );
      return null;
    }
  }

  /// Tải thông tin chi tiết của trận đấu
  Future<MatchDetailEntity?> _loadMatchDetail(int matchId, int roundId) async {
    try {
      final result = await _matchDetailService.getMatchDetail(matchId, roundId);

      return result.fold(
        (error) {
          emit(
            state.copyWith(
              status: MatchDetailStatus.failure,
              errorMessage: error.toString(),
            ),
          );
          return null;
        },
        (matchDetail) {
          return matchDetail;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.failure,
          errorMessage: 'Lỗi khi tải thông tin trận đấu: $e',
        ),
      );
      return null;
    }
  }

  /// Cập nhật điểm số của trận đấu
  Future<void> updateMatchScore({
    required int homePoints,
    required int awayPoints,
    required int homeFouls,
    required int awayFouls,
    required int attendance,
  }) async {
    if (state.match == null || state.matchId == null) return;

    emit(state.copyWith(status: MatchDetailStatus.updating));

    try {
      // Gọi service để cập nhật tỉ số và số lỗi
      final result = await _matchDetailService.updateMatchScore(
        matchId: state.matchId!,
        homeScore: homePoints,
        awayScore: awayPoints,
        homeFouls: homeFouls,
        awayFouls: awayFouls,
      );

      return result.fold(
        (error) {
          emit(
            state.copyWith(
              status: MatchDetailStatus.updateFailure,
              errorMessage: 'Lỗi khi cập nhật trận đấu: ${error.toString()}',
            ),
          );
        },
        (updatedMatch) async {
          // Tải lại thông tin chi tiết trận đấu
          final matchDetail = await _loadMatchDetail(
            state.matchId!,
            state.roundId!,
          );

          if (matchDetail != null) {
            emit(
              state.copyWith(
                match: matchDetail,
                status: MatchDetailStatus.updateSuccess,
              ),
            );

            // Sau 2 giây, đặt lại trạng thái về success
            Future.delayed(const Duration(seconds: 2), () {
              emit(state.copyWith(status: MatchDetailStatus.success));
            });
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.updateFailure,
          errorMessage: 'Lỗi khi cập nhật trận đấu: $e',
        ),
      );
    }
  }

  /// Tải lại thông tin trận đấu
  Future<void> refreshMatchDetail() async {
    emit(state.copyWith(status: MatchDetailStatus.loading));
    await _loadMatchDetail(state.matchId!, state.roundId!);
    await _loadMatchReferees(state.matchId!);
  }

  /// Tải danh sách trọng tài của trận đấu
  Future<List<MatchRefereeDetailEntity>?> _loadMatchReferees(
    int matchId,
  ) async {
    try {
      final result = await _matchDetailService.getMatchReferees(matchId);

      return result.fold(
        (error) {
          emit(
            state.copyWith(
              status: MatchDetailStatus.failure,
              errorMessage: error.toString(),
            ),
          );
          return null;
        },
        (referees) {
          return referees;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      return null;
    }
  }

  /// Tự động phân công trọng tài cho trận đấu
  Future<void> generateMatchReferees({
    required int roundId,
    required int matchId,
  }) async {
    emit(state.copyWith(status: MatchDetailStatus.updating));

    try {
      final result = await _matchDetailService.generateMatchReferees(
        roundId: roundId,
        matchId: matchId,
      );
      result.fold(
        (error) => emit(
          state.copyWith(
            status: MatchDetailStatus.updateFailure,
            errorMessage: 'Lỗi khi phân công trọng tài: ${error.toString()}',
          ),
        ),
        (matchReferees) async {
          if (matchReferees.length < 4) {
            emit(
              state.copyWith(
                status: MatchDetailStatus.updateFailure,
                errorMessage: 'Không đủ trọng tài để phân công trận đấu',
              ),
            );
            return;
          }
          // Tải lại danh sách trọng tài
          await _loadMatchReferees(matchId);

          emit(state.copyWith(status: MatchDetailStatus.updateSuccess));

          // Sau 2 giây, đặt lại trạng thái về success
          Future.delayed(const Duration(seconds: 2), () {
            emit(state.copyWith(status: MatchDetailStatus.success));
          });
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.updateFailure,
          errorMessage: 'Lỗi khi phân công trọng tài: $e',
        ),
      );
    }
  }

  /// Xóa trọng tài khỏi trận đấu
  Future<void> deleteMatchReferee(String id) async {
    emit(state.copyWith(status: MatchDetailStatus.updating));

    try {
      final result = await _matchDetailService.deleteMatchReferee(id);

      result.fold(
        (error) => emit(
          state.copyWith(
            status: MatchDetailStatus.updateFailure,
            errorMessage: 'Lỗi khi xóa trọng tài: ${error.toString()}',
          ),
        ),
        (success) async {
          // Tải lại danh sách trọng tài
          await _loadMatchReferees(state.matchId!);

          emit(state.copyWith(status: MatchDetailStatus.updateSuccess));

          // Sau 2 giây, đặt lại trạng thái về success
          Future.delayed(const Duration(seconds: 2), () {
            emit(state.copyWith(status: MatchDetailStatus.success));
          });
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.updateFailure,
          errorMessage: 'Lỗi khi xóa trọng tài: $e',
        ),
      );
    }
  }

  /// Tự động thêm cầu thủ vào trận đấu
  Future<void> autoRegisterHomePlayersForMatch() async {
    if (state.match == null || state.matchId == null) return;

    emit(state.copyWith(status: MatchDetailStatus.loadingPlayers));

    try {
      // Lấy thông tin đội nhà và đội khách
      final homeTeamId = state.match!.homeTeamId;

      if (homeTeamId == null) {
        emit(
          state.copyWith(
            status: MatchDetailStatus.loadPlayersFailure,
            errorMessage: 'Không tìm thấy thông tin đội bóng',
          ),
        );
        return;
      }

      // Gọi service để tự động thêm cầu thủ vào trận đấu
      final result = await _matchDetailService.autoRegisterPlayersForMatch(
        state.matchId!,
        _match!.homeSeasonTeamId!,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            status: MatchDetailStatus.loadPlayersFailure,
            errorMessage: 'Lỗi khi tự động thêm cầu thủ: ${error.toString()}',
          ),
        ),
        (playerIds) async {
          if (playerIds.isEmpty) {
            emit(
              state.copyWith(
                status: MatchDetailStatus.loadPlayersFailure,
                errorMessage: 'Không có cầu thủ nào được thêm vào trận đấu',
              ),
            );
            return;
          }
          final homePlayers = await _getTeamPlayersDetailInMatch(
            state.matchId!,
            _match!.homeSeasonTeamId!,
          );

          emit(
            state.copyWith(
              status: MatchDetailStatus.loadPlayersSuccess,
              registeredPlayerIds:
                  playerIds.map((id) => id.toString()).toList(),
              homeTeamPlayers: homePlayers,
            ),
          );

          // Sau 2 giây, đặt lại trạng thái về success
          Future.delayed(const Duration(seconds: 2), () {
            emit(state.copyWith(status: MatchDetailStatus.success));
          });
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.loadPlayersFailure,
          errorMessage: 'Lỗi khi tự động thêm cầu thủ: $e',
        ),
      );
    }
  }

  Future<void> autoRegisterAwayPlayersForMatch() async {
    if (state.match == null || state.matchId == null) return;

    emit(state.copyWith(status: MatchDetailStatus.loadingPlayers));

    try {
      // Lấy thông tin đội khách
      final awayTeamId = state.match!.awayTeamId;

      if (awayTeamId == null) {
        emit(
          state.copyWith(
            status: MatchDetailStatus.loadPlayersFailure,
            errorMessage: 'Không tìm thấy thông tin đội bóng',
          ),
        );
        return;
      }

      // Gọi service để tự động thêm cầu thủ vào trận đấu
      final result = await _matchDetailService.autoRegisterPlayersForMatch(
        state.matchId!,
        _match!.awaySeasonTeamId!,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            status: MatchDetailStatus.loadPlayersFailure,
            errorMessage: 'Lỗi khi tự động thêm cầu thủ: ${error.toString()}',
          ),
        ),
        (playerIds) async {
          if (playerIds.isEmpty) {
            emit(
              state.copyWith(
                status: MatchDetailStatus.loadPlayersFailure,
                errorMessage: 'Không có cầu thủ nào được thêm vào trận đấu',
              ),
            );
            return;
          }

          final awayPlayers = await _getTeamPlayersDetailInMatch(
            state.matchId!,
            _match!.awaySeasonTeamId!,
          );

          emit(
            state.copyWith(
              status: MatchDetailStatus.loadPlayersSuccess,
              registeredPlayerIds:
                  playerIds.map((id) => id.toString()).toList(),
              awayTeamPlayers: awayPlayers,
            ),
          );

          // Sau 2 giây, đặt lại trạng thái về success
          Future.delayed(const Duration(seconds: 2), () {
            emit(state.copyWith(status: MatchDetailStatus.success));
          });
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.loadPlayersFailure,
          errorMessage: 'Lỗi khi tự động thêm cầu thủ: $e',
        ),
      );
    }
  }

  /// Giả lập tỉ số và số lỗi cho trận đấu
  Future<void> simulateMatchScore() async {
    if (state.matchId == null) return;

    emit(state.copyWith(status: MatchDetailStatus.updating));

    try {
      final playerStatsResult = await _matchDetailService.simulatePlayerStats(
        matchId: state.matchId!,
      );
      playerStatsResult.fold((error) => null, (playerStatsMap) async {
        final result = await _matchDetailService.simulateMatchScore(
          matchId: state.matchId!,
          homePlayerStats:
              playerStatsMap['home'] as List<MatchPlayerStatsEntity>,
          awayPlayerStats:
              playerStatsMap['away'] as List<MatchPlayerStatsEntity>,
        );

        return result.fold(
          (error) {
            emit(
              state.copyWith(
                status: MatchDetailStatus.updateFailure,
                errorMessage:
                    'Lỗi khi giả lập tỉ số trận đấu: ${error.toString()}',
              ),
            );
          },
          (updatedMatch) async {
            // Tải lại thông tin chi tiết trận đấu
            final matchDetail = await _loadMatchDetail(
              state.matchId!,
              state.roundId!,
            );

            if (matchDetail != null) {
              final playersResult = await Future.wait([
                _getTeamPlayersDetailInMatch(
                  matchDetail.matchId!,
                  _match!.homeSeasonTeamId!,
                ),
                _getTeamPlayersDetailInMatch(
                  state.matchId!,
                  _match!.awaySeasonTeamId!,
                ),
              ]);
              if (!AppUtils.isNullEmptyList(playersResult) &&
                  playersResult[0] != null &&
                  playersResult[1] != null) {
                emit(
                  state.copyWith(
                    match: matchDetail,
                    homeTeamPlayers:
                        playersResult[0] as List<MatchPlayerDetailEntity>,
                    awayTeamPlayers:
                        playersResult[1] as List<MatchPlayerDetailEntity>,
                    status: MatchDetailStatus.updateSuccess,
                  ),
                );
              }

              // Sau 2 giây, đặt lại trạng thái về success
              Future.delayed(const Duration(seconds: 2), () {
                emit(state.copyWith(status: MatchDetailStatus.success));
              });
            }
          },
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.updateFailure,
          errorMessage: 'Lỗi khi giả lập tỉ số trận đấu: $e',
        ),
      );
    }
  }
}
