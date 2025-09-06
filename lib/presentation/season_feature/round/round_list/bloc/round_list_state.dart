import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:equatable/equatable.dart';

/// Các trạng thái có thể có của màn hình danh sách vòng đấu
enum RoundListStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu
  loading,

  /// Tải dữ liệu thành công
  success,

  /// Tải dữ liệu thất bại
  failure,

  /// Đang tạo vòng đấu
  creating,

  /// Tạo vòng đấu thành công
  createSuccess,

  /// Tạo vòng đấu thất bại
  createFailure,
}

/// State của màn hình danh sách vòng đấu
class RoundListState extends Equatable {
  /// Trạng thái hiện tại
  final RoundListStatus status;

  /// Danh sách vòng đấu
  final List<RoundEntity> rounds;

  /// ID của mùa giải đang xem
  final int? seasonId;

  /// Thông báo lỗi (nếu có)
  final String? errorMessage;

  /// Constructor
  const RoundListState({
    this.status = RoundListStatus.initial,
    this.rounds = const [],
    this.seasonId,
    this.errorMessage,
  });

  /// Tạo bản sao với các giá trị mới
  RoundListState copyWith({
    RoundListStatus? status,
    List<RoundEntity>? rounds,
    int? seasonId,
    String? errorMessage,
  }) {
    return RoundListState(
      status: status ?? this.status,
      rounds: rounds ?? this.rounds,
      seasonId: seasonId ?? this.seasonId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rounds, seasonId, errorMessage];
}
