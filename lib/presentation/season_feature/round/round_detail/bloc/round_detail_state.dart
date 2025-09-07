import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:equatable/equatable.dart';

/// Trạng thái của màn hình chi tiết vòng đấu
enum RoundDetailStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu
  loading,

  /// Tải dữ liệu thành công
  success,

  /// Tải dữ liệu thất bại
  failure,

  /// Đang tạo trận đấu
  creating,

  /// Tạo trận đấu thành công
  createSuccess,

  /// Tạo trận đấu thất bại
  createFailure,
}

/// State của màn hình chi tiết vòng đấu
class RoundDetailState extends Equatable {
  /// ID của vòng đấu
  final int? roundId;

  /// Thông tin chi tiết của vòng đấu
  final RoundEntity? round;

  /// Danh sách trận đấu trong vòng đấu
  final List<MatchDetailEntity> matches;

  /// Trạng thái của màn hình
  final RoundDetailStatus status;

  /// Thông báo lỗi (nếu có)
  final String? errorMessage;

  /// Constructor
  const RoundDetailState({
    this.roundId,
    this.round,
    this.matches = const [],
    this.status = RoundDetailStatus.initial,
    this.errorMessage,
  });

  /// Tạo state ban đầu
  factory RoundDetailState.initial() => const RoundDetailState();

  /// Tạo bản sao của state với các giá trị mới
  RoundDetailState copyWith({
    int? roundId,
    RoundEntity? round,
    List<MatchDetailEntity>? matches,
    RoundDetailStatus? status,
    String? errorMessage,
  }) {
    return RoundDetailState(
      roundId: roundId ?? this.roundId,
      round: round ?? this.round,
      matches: matches ?? this.matches,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [roundId, round, matches, status, errorMessage];
}
