import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyPlayerList extends StatelessWidget {
  const EmptyPlayerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImageWidget(
            path: AppImagePaths.empty_anm,
            height: 120.sp,
            width: 120.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có cầu thủ nào',
            style: AppStyle.headline5.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Hãy thêm cầu thủ mới bằng nút + bên dưới',
            style: AppStyle.bodyMedium,
          ),
          SizedBox(height: 8.h),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.orange),
            ),
            onPressed: () {
              context.read<PlayerListCubit>().createRandomGeneratedPlayerList();
            },
            child: Text(
              'Tạo ngẫu nhiên',
              style: AppStyle.buttonMedium.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
