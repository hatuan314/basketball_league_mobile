import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:equatable/equatable.dart';

/// Trạng thái của màn hình chi tiết trận đấu
enum MatchDetailStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu
  loading,

  /// Tải dữ liệu thành công
  success,

  /// Tải dữ liệu thất bại
  failure,

  /// Đang cập nhật dữ liệu
  updating,

  /// Cập nhật dữ liệu thành công
  updateSuccess,

  /// Cập nhật dữ liệu thất bại
  updateFailure,
}

/// State của màn hình chi tiết trận đấu
class MatchDetailState extends Equatable {
  /// ID của trận đấu
  final int? matchId;

  /// ID của vòng đấu
  final int? roundId;

  /// Thông tin chi tiết của trận đấu
  final MatchDetailEntity? match;

  /// Thông tin trọng tài của trận đấu
  final List<MatchRefereeDetailEntity>? referees;

  /// Trạng thái của màn hình
  final MatchDetailStatus status;

  /// Thông báo lỗi
  final String? errorMessage;

  /// Constructor
  const MatchDetailState({
    this.matchId,
    this.roundId,
    this.match,
    this.referees,
    this.status = MatchDetailStatus.initial,
    this.errorMessage,
  });

  /// Trạng thái ban đầu
  factory MatchDetailState.initial() =>
      const MatchDetailState(status: MatchDetailStatus.initial);

  /// Trạng thái đang tải
  factory MatchDetailState.loading() =>
      const MatchDetailState(status: MatchDetailStatus.loading);

  /// Tạo bản sao với các giá trị mới
  MatchDetailState copyWith({
    int? matchId,
    int? roundId,
    MatchDetailEntity? match,
    List<MatchRefereeDetailEntity>? referees,
    MatchDetailStatus? status,
    String? errorMessage,
  }) {
    return MatchDetailState(
      matchId: matchId ?? this.matchId,
      roundId: roundId ?? this.roundId,
      match: match ?? this.match,
      referees: referees ?? this.referees,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [matchId, roundId, match, status, errorMessage];
}
