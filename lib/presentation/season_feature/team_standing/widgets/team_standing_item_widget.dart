import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamStandingItemWidget extends StatelessWidget {
  final TeamStandingEntity team;
  final int rank;
  const TeamStandingItemWidget({
    super.key,
    required this.team,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
    final backgroundColor =
        isTopThree ? AppColors.primary.withOpacity(0.05) : Colors.transparent;
    final rankColor =
        rank == 1
            ? Colors.amber
            : rank == 2
            ? Colors.grey[400]
            : rank == 3
            ? Colors.brown[300]
            : Colors.black;

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 4.sp),
      child: Row(
        children: [
          SizedBox(
            width: 40.sp,
            child: Text(
              '$rank',
              style: TextStyle(fontWeight: FontWeight.bold, color: rankColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              team.teamName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text('${team.totalWins ?? 0}', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(
              '${team.totalLosses ?? 0}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${team.pointDifference ?? 0}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    (team.pointDifference ?? 0) > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${team.totalPoints ?? 0}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
