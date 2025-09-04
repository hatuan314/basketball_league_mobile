import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptySeasonDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImageWidget(
            path: AppImagePaths.empty_anm,
            height: 150.sp,
            width: 150.sp,
          ),
          SizedBox(height: 16.sp),
          Text(
            'Chưa có mùa giải nào',
            style: AppStyle.headline5.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.sp),
          Text(
            'Hãy thêm mùa giải mới bằng nút + bên dưới',
            style: AppStyle.bodyMedium,
          ),
          SizedBox(height: 16.sp),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.orange),
            ),
            onPressed: () {
              context.read<HomeCubit>().createRandomSeasons();
            },
            child: Text(
              'Tạo mùa giải ngẫu nhiên',
              style: AppStyle.buttonMedium.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
