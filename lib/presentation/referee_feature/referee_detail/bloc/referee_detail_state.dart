import 'package:baseketball_league_mobile/domain/entities/referee_entity.dart';
import 'package:equatable/equatable.dart';

/// Các trạng thái của màn hình chi tiết trọng tài
enum RefereeDetailStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu
  loading,

  /// Tải dữ liệu thành công
  success,

  /// Tải dữ liệu thất bại
  failure,
}

/// Lớp quản lý trạng thái của màn hình chi tiết trọng tài
class RefereeDetailState extends Equatable {
  /// Trạng thái hiện tại của màn hình
  final RefereeDetailStatus status;

  /// Thông tin chi tiết trọng tài
  final RefereeEntity? referee;

  /// Thông báo lỗi
  final String? errorMessage;

  /// Constructor
  const RefereeDetailState({
    this.status = RefereeDetailStatus.initial,
    this.referee,
    this.errorMessage,
  });

  /// Tạo bản sao với các thuộc tính mới
  RefereeDetailState copyWith({
    RefereeDetailStatus? status,
    RefereeEntity? referee,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RefereeDetailState(
      status: status ?? this.status,
      referee: referee ?? this.referee,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, referee, errorMessage];
}
