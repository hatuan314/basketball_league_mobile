import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/presentation/home/bloc/home_cubit.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // _getSchemas();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('PBL', style: AppStyle.headline4),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return AppLoading();
          } else if (state.status == HomeStatus.error) {
            return _buildErrorView(state.errorMessage ?? 'Đã xảy ra lỗi');
          } else {
            return Padding(
              padding: EdgeInsets.all(16.sp),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.sp,
                  mainAxisSpacing: 4.sp,
                  childAspectRatio: 0.8,
                ),
                children: [
                  MenuButtonWidget(
                    iconPath: AppImagePaths.basketball_season,
                    title: "Danh sách\nGiải đấu",
                    onTap: () {
                      context.push(RouterName.seasonList);
                    },
                  ),
                  MenuButtonWidget(
                    iconPath: AppImagePaths.basketball_team,
                    title: "Danh sách\nđội bóng",
                    onTap: () {
                      context.push(RouterName.teamList);
                    },
                  ),
                  MenuButtonWidget(
                    iconPath: AppImagePaths.stadium,
                    color: AppColors.orange,
                    title: "Danh sách\nsân vận động",
                    onTap: () {},
                  ),
                  MenuButtonWidget(
                    iconPath: AppImagePaths.sports_basketball_shirt_player,
                    color: AppColors.orange,
                    title: "Danh sách\ncầu thủ",
                    onTap: () {
                      context.push(RouterName.playerList);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.sp),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.sp),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().initial();
            },
            child: Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
