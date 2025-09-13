import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SeasonDetailScreen extends StatefulWidget {
  final SeasonEntity season;
  const SeasonDetailScreen({super.key, required this.season});

  @override
  State<StatefulWidget> createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.season.name ?? 'Giải đấu',
          style: AppStyle.headline4,
        ),
      ),
      body: Padding(
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
              iconPath: AppImagePaths.chart_bar,
              color: AppColors.orange,
              title: "Bảng\nxếp hạng",
              onTap: () {
                context.push(
                  RouterName.teamStanding.toSeasonDetailRoute(),
                  extra: widget.season,
                );
              },
            ),
            MenuButtonWidget(
              iconPath: AppImagePaths.season_round,
              color: AppColors.orange,
              title: "Danh sách\nvòng đấu",
              onTap: () {
                context.push(
                  RouterName.roundList.toSeasonDetailRoute(),
                  extra: widget.season.id,
                );
              },
            ),
            MenuButtonWidget(
              iconPath: AppImagePaths.sports_basketball_shirt_player,
              color: AppColors.orange,
              title: "Bảng xếp hạng\ncầu thủ",
              onTap: () {
                context.push(
                  RouterName.topPlayer.toSeasonDetailRoute(),
                  extra: widget.season.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
