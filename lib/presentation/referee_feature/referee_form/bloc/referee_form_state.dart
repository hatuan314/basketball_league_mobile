import 'package:baseketball_league_mobile/domain/entities/referee/referee_entity.dart';
import 'package:equatable/equatable.dart';

/// Các trạng thái của màn hình form trọng tài
enum RefereeFormStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu
  loading,

  /// Đang lưu dữ liệu
  saving,

  /// Lưu dữ liệu thành công
  saveSuccess,

  /// Lưu dữ liệu thất bại
  saveFailure,
}

/// Lớp quản lý trạng thái của màn hình form trọng tài
class RefereeFormState extends Equatable {
  /// Trạng thái hiện tại của màn hình
  final RefereeFormStatus status;

  /// Thông tin trọng tài đang chỉnh sửa
  final RefereeEntity? referee;

  /// Thông báo lỗi
  final String? errorMessage;

  /// Constructor
  const RefereeFormState({
    this.status = RefereeFormStatus.initial,
    this.referee,
    this.errorMessage,
  });

  /// Tạo bản sao với các thuộc tính mới
  RefereeFormState copyWith({
    RefereeFormStatus? status,
    RefereeEntity? referee,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RefereeFormState(
      status: status ?? this.status,
      referee: referee ?? this.referee,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, referee, errorMessage];
}
