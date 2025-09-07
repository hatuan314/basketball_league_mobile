import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/bloc/referee_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/bloc/referee_list_state.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_list/widgets/referee_item_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RefereeListView extends StatelessWidget {
  const RefereeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RefereeListCubit, RefereeListState>(
      listenWhen:
          (previous, current) =>
              current.status == RefereeListStatus.generateSuccess ||
              current.status == RefereeListStatus.generateFailure,
      listener: (context, state) {
        if (state.status == RefereeListStatus.generateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã tạo thành công ${state.generatedCount} trọng tài',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == RefereeListStatus.generateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // Đang tải dữ liệu
        if (state.status == RefereeListStatus.loading ||
            state.status == RefereeListStatus.initial) {
          return const Center(child: AppLoading());
        }

        // Lỗi khi tải dữ liệu
        if (state.status == RefereeListStatus.failure) {
          return AppErrorStateWidget(
            errorMessage: state.errorMessage ?? 'Đã xảy ra lỗi',
            onRetry: () {
              context.read<RefereeListCubit>().getReferees();
            },
          );
        }

        // Danh sách trống
        if (state.referees.isEmpty) {
          return EmptyWidget(
            message: 'Chưa có trọng tài nào',
            description: 'Hãy thêm trọng tài mới bằng nút + bên dưới',
            buttonText: 'Tạo dữ liệu mẫu',
            onButtonPressed: () {
              context.read<RefereeListCubit>().generateMockData();
            },
          );
        }

        // Hiển thị danh sách trọng tài
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<RefereeListCubit>().getReferees();
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.sp),
            itemCount: state.referees.length,
            itemBuilder: (context, index) {
              final referee = state.referees[index];
              return RefereeItemCard(
                referee: referee,
                onViewDetail: () {
                  context.push(
                    RouterName.refereeDetail.toRefereeRoute(),
                    extra: referee.id!,
                  );
                },
                onEdit: () {
                  context.push(
                    RouterName.refereeEdit.toRefereeRoute(),
                    extra: referee.id!,
                  );
                },
                onDelete: () {
                  _showDeleteConfirmDialog(context, referee.id!);
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Hiển thị dialog xác nhận xóa trọng tài
  void _showDeleteConfirmDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text(
              'Bạn có chắc chắn muốn xóa trọng tài này không?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Hủy',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<RefereeListCubit>().deleteReferee(id);
                },
                child: Text(
                  'Xóa',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
