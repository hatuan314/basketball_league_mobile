import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_detail/widgets/menu_button_widget.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SeasonDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.sp,
            mainAxisSpacing: 16.sp,
            childAspectRatio: 0.8,
          ),
          children: [
            MenuButtonWidget(
              iconPath: AppImagePaths.basketball_season,
              title: "Danh sách\ngiải đấu",
              onTap: () {},
            ),
            MenuButtonWidget(
              iconPath: AppImagePaths.basketball_team,
              title: "Danh sách\nđội bóng",
              onTap: () {},
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
      ),
    );
  }
}
