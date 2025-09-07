import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit để quản lý state của màn hình chi tiết trận đấu
class MatchDetailCubit extends Cubit<MatchDetailState> {
  /// UseCase để quản lý trận đấu
  final MatchUseCase _matchUseCase;

  /// Constructor
  MatchDetailCubit({required MatchUseCase matchUseCase})
    : _matchUseCase = matchUseCase,
      super(MatchDetailState.initial());

  /// Thiết lập thông tin ban đầu và tải dữ liệu
  void initial({required int matchId, required int roundId}) async {
    emit(
      state.copyWith(
        matchId: matchId,
        roundId: roundId,
        status: MatchDetailStatus.loading,
      ),
    );

    await _loadMatchDetail();
  }

  /// Tải thông tin chi tiết của trận đấu
  Future<void> _loadMatchDetail() async {
    if (state.matchId == null || state.roundId == null) return;

    try {
      final result = await _matchUseCase.getMatchDetailByRoundId(
        state.roundId!,
        matchId: state.matchId,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            status: MatchDetailStatus.failure,
            errorMessage: error.toString(),
          ),
        ),
        (matches) {
          if (matches.isEmpty) {
            emit(
              state.copyWith(
                status: MatchDetailStatus.failure,
                errorMessage: 'Không tìm thấy thông tin trận đấu',
              ),
            );
          } else {
            emit(
              state.copyWith(
                match: matches.first,
                status: MatchDetailStatus.success,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MatchDetailStatus.failure,
          errorMessage: 'Lỗi khi tải thông tin trận đấu: $e',
        ),
      );
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
      // Tạo bản sao của match với các giá trị mới
      final updatedMatch = MatchDetailEntity(
        matchId: state.match!.matchId,
        matchDate: state.match!.matchDate,
        roundId: state.match!.roundId,
        roundNo: state.match!.roundNo,
        seasonId: state.match!.seasonId,
        seasonName: state.match!.seasonName,
        homeTeamId: state.match!.homeTeamId,
        awayTeamId: state.match!.awayTeamId,
        homeTeamName: state.match!.homeTeamName,
        awayTeamName: state.match!.awayTeamName,
        homeColor: state.match!.homeColor,
        awayColor: state.match!.awayColor,
        homePoints: homePoints,
        awayPoints: awayPoints,
        homeFouls: homeFouls,
        awayFouls: awayFouls,
        attendance: attendance,
        stadiumId: state.match!.stadiumId,
        stadiumName: state.match!.stadiumName,
        ticketPrice: state.match!.ticketPrice,
        // Cập nhật đội thắng dựa trên điểm số mới
        winnerTeamId:
            homePoints > awayPoints
                ? state.match!.homeTeamId
                : awayPoints > homePoints
                ? state.match!.awayTeamId
                : null,
        winnerTeamName:
            homePoints > awayPoints
                ? state.match!.homeTeamName
                : awayPoints > homePoints
                ? state.match!.awayTeamName
                : null,
      );

      // Gọi API để cập nhật trận đấu
      // Lưu ý: Cần triển khai phương thức updateMatchDetail trong MatchUseCase
      // Hiện tại chỉ mô phỏng việc cập nhật thành công
      await Future.delayed(const Duration(seconds: 1));

      emit(
        state.copyWith(
          match: updatedMatch,
          status: MatchDetailStatus.updateSuccess,
        ),
      );

      // Sau 2 giây, đặt lại trạng thái về success
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: MatchDetailStatus.success));
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
    await _loadMatchDetail();
  }
}
