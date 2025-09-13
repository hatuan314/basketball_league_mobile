import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/bloc/referee_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/bloc/referee_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/widgets/referee_info_widget.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_detail/widgets/referee_monthly_salary_listview.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Màn hình chi tiết trọng tài
class RefereeDetailScreen extends StatefulWidget {
  /// ID của trọng tài
  final int refereeId;

  /// Constructor
  const RefereeDetailScreen({super.key, required this.refereeId});

  @override
  State<RefereeDetailScreen> createState() => _RefereeDetailScreenState();
}

class _RefereeDetailScreenState extends State<RefereeDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Lấy thông tin chi tiết trọng tài khi màn hình được khởi tạo
    context.read<RefereeDetailCubit>().initia(widget.refereeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết trọng tài', style: AppStyle.headline4),
        actions: [
          // Nút chỉnh sửa
          IconButton(
            onPressed: () {
              context.push(
                RouterName.refereeEdit.toRefereeRoute(),
                extra: widget.refereeId,
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Chỉnh sửa',
          ),
        ],
      ),
      body: BlocBuilder<RefereeDetailCubit, RefereeDetailState>(
        builder: (context, state) {
          // Đang tải dữ liệu
          if (state.status == RefereeDetailStatus.loading ||
              state.status == RefereeDetailStatus.initial) {
            return const Center(child: AppLoading());
          }

          // Lỗi khi tải dữ liệu
          if (state.status == RefereeDetailStatus.failure) {
            return AppErrorStateWidget(
              errorMessage: state.errorMessage ?? 'Đã xảy ra lỗi',
              onRetry: () {
                context.read<RefereeDetailCubit>().getRefereeDetail(
                  widget.refereeId,
                );
              },
            );
          }

          // Hiển thị thông tin chi tiết trọng tài
          final referee = state.referee!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar và tên
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.2,
                        ),
                        radius: 48.sp,
                        child: AppImageWidget(
                          path: AppImagePaths.referee,
                          width: 48.sp,
                          height: 48.sp,
                          color: AppColors.orange,
                        ),
                      ),
                      SizedBox(height: 16.sp),
                      Text(
                        referee.fullName ?? 'Không có tên',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.sp),
                // Thông tin chi tiết
                RefereeInfoWidget(referee: state.referee!),
                SizedBox(height: 32.sp),
                RefereeMonthlySalaryListview(
                  monthlySalaries: state.monthlySalaries!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Xây dựng một mục thông tin
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.sp, color: AppColors.grey),
          SizedBox(width: 16.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
                ),
                SizedBox(height: 4.sp),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
