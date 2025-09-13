import 'package:baseketball_league_mobile/domain/entities/round/round_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/round/top_scores_by_round_entity.dart';
import 'package:baseketball_league_mobile/domain/match/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/round_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/bloc/round_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit quản lý logic của màn hình chi tiết vòng đấu
class RoundDetailCubit extends Cubit<RoundDetailState> {
  final RoundUseCase _roundUseCase;
  final MatchUseCase _matchUseCase;

  /// Constructor
  RoundDetailCubit({
    required RoundUseCase roundUseCase,
    required MatchUseCase matchUseCase,
  }) : _roundUseCase = roundUseCase,
       _matchUseCase = matchUseCase,
       super(RoundDetailState(status: RoundDetailStatus.loading));

  /// Thiết lập ID vòng đấu và tải dữ liệu
  void initial(int roundId) async {
    emit(state.copyWith(roundId: roundId, status: RoundDetailStatus.loading));
    final results = await Future.wait([
      _loadRoundDetail(),
      _loadMatches(),
      _loadTopScoresByRound(),
    ]);
    if (results[0] != null && results[1] != null) {
      emit(
        state.copyWith(
          round: results[0] as RoundEntity,
          matches: results[1] as List<MatchDetailEntity>,
          topScoresByRound: results[2] as TopScoresByRoundEntity?,
          status: RoundDetailStatus.initial,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: RoundDetailStatus.failure,
          errorMessage: 'Không tìm thấy thông tin vòng đấu',
        ),
      );
    }
  }

  /// Tải thông tin chi tiết của vòng đấu
  Future<RoundEntity?> _loadRoundDetail() async {
    if (state.roundId == null) return null;

    emit(state.copyWith(status: RoundDetailStatus.loading));

    final result = await _roundUseCase.getRoundById(state.roundId!);

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            status: RoundDetailStatus.failure,
            errorMessage: error.toString(),
          ),
        );
        return null;
      },
      (round) {
        return round;
      },
    );
  }

  /// Tải cầu thủ có điểm số cao nhất trong vòng đấu
  Future<TopScoresByRoundEntity?> _loadTopScoresByRound() async {
    if (state.roundId == null) return null;

    emit(state.copyWith(status: RoundDetailStatus.loading));

    final result = await _roundUseCase.getTopScoresByRound(
      seasonId: state.roundId!,
      roundId: state.roundId!,
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            status: RoundDetailStatus.failure,
            errorMessage: error.toString(),
          ),
        );
        return null;
      },
      (topScoresByRound) {
        return topScoresByRound;
      },
    );
  }

  /// Tải danh sách trận đấu trong vòng đấu
  Future<List<MatchDetailEntity>?> _loadMatches() async {
    if (state.roundId == null) return null;

    emit(state.copyWith(status: RoundDetailStatus.loading));

    final result = await _matchUseCase.getMatchDetailByRoundId(state.roundId!);

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            status: RoundDetailStatus.failure,
            errorMessage: error.toString(),
          ),
        );
        return null;
      },
      (matches) {
        return matches;
      },
    );
  }

  /// Tạo các trận đấu cho vòng đấu
  Future<void> generateMatches() async {
    if (state.roundId == null) return;

    emit(state.copyWith(status: RoundDetailStatus.creating));

    final result = await _matchUseCase.generateMatches(state.roundId!);

    result.fold(
      (error) => emit(
        state.copyWith(
          status: RoundDetailStatus.createFailure,
          errorMessage: error.toString(),
        ),
      ),
      (matches) async {
        final List<MatchDetailEntity>? matchDetails = await _loadMatches();
        emit(
          state.copyWith(
            matches: matchDetails,
            status: RoundDetailStatus.createSuccess,
          ),
        );
      },
    );
  }
}
