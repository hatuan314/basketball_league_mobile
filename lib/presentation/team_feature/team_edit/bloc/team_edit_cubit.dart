import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/team_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'team_edit_state.dart';

class TeamEditCubit extends Cubit<TeamEditState> {
  final TeamUsecase teamUsecase;

  TeamEditCubit({required this.teamUsecase})
      : super(TeamEditState(status: TeamEditStatus.initial));

  /// Khởi tạo trạng thái ban đầu dựa vào việc có đang chỉnh sửa đội bóng hay không
  void initialize({bool isEditing = false}) {
    emit(state.copyWith(isEditing: isEditing));
  }

  /// Thêm đội bóng mới
  Future<bool> addTeam(TeamEntity team) async {
    emit(state.copyWith(status: TeamEditStatus.loading));
    EasyLoading.show(status: 'Đang thêm đội bóng...');
    
    final result = await teamUsecase.createTeam(team);
    
    return result.fold(
      (exception) {
        EasyLoading.dismiss();
        emit(
          state.copyWith(
            status: TeamEditStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
        return false;
      },
      (success) {
        EasyLoading.dismiss();
        emit(state.copyWith(status: TeamEditStatus.success));
        return success;
      },
    );
  }

  /// Cập nhật thông tin đội bóng
  Future<bool> updateTeam(TeamEntity team) async {
    emit(state.copyWith(status: TeamEditStatus.loading));
    EasyLoading.show(status: 'Đang cập nhật đội bóng...');
    
    final result = await teamUsecase.updateTeam(team);
    
    return result.fold(
      (exception) {
        EasyLoading.dismiss();
        emit(
          state.copyWith(
            status: TeamEditStatus.failure,
            errorMessage: exception.toString(),
          ),
        );
        return false;
      },
      (success) {
        EasyLoading.dismiss();
        emit(state.copyWith(status: TeamEditStatus.success));
        return success;
      },
    );
  }
}
