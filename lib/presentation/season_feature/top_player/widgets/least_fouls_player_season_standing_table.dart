import 'package:baseketball_league_mobile/domain/entities/least_fouls_player_season_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeastFoulsPlayerSeasonStandingTable extends StatelessWidget {
  final List<LeastFoulsPlayerSeasonEntity> leastFoulsPlayerSeasonList;
  const LeastFoulsPlayerSeasonStandingTable({
    super.key,
    required this.leastFoulsPlayerSeasonList,
  });

  @override
  Widget build(BuildContext context) {
    if (leastFoulsPlayerSeasonList.isEmpty) {
      return const EmptyWidget(message: 'Không có dữ liệu cầu thủ ít lỗi');
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(height: 1, thickness: 1),
          _buildTableContent(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 8.sp),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40.sp,
            child: Text(
              'Hạng',
              style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 8.sp),
          Expanded(
            flex: 2,
            child: Text(
              'Cầu thủ',
              style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Đội',
              style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 60.sp,
            child: Text(
              'Lỗi',
              style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leastFoulsPlayerSeasonList.length,
      separatorBuilder:
          (context, index) => const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final player = leastFoulsPlayerSeasonList[index];
        final rank = index + 1;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 8.sp),
          color:
              index % 2 == 0
                  ? Colors.white
                  : Colors.grey.withValues(alpha: 0.05),
          child: Row(
            children: [
              SizedBox(
                width: 40.sp,
                child: Text(
                  rank.toString(),
                  style: AppStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getRankColor(rank),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 8.sp),
              Expanded(
                flex: 2,
                child: Text(
                  player.playerName ?? 'N/A',
                  style: AppStyle.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  player.teamName ?? 'N/A',
                  style: AppStyle.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 60.sp,
                child: Text(
                  '${player.totalFouls ?? 0}',
                  style: AppStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getFoulColor(player.totalFouls ?? 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade600;
      case 3:
        return Colors.brown.shade300;
      default:
        return Colors.black;
    }
  }

  Color _getFoulColor(int fouls) {
    if (fouls <= 5) {
      return Colors.green;
    } else if (fouls <= 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
