import 'package:baseketball_league_mobile/common/enums.dart';
import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchRefereeCard extends StatelessWidget {
  final MatchDetailEntity match;
  final List<MatchRefereeDetailEntity>? referees;
  const MatchRefereeCard({super.key, this.referees, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Trọng tài', style: AppStyle.headline5)],
            ),
            SizedBox(height: 16.sp),

            if (referees == null || referees!.isEmpty)
              EmptyWidget(
                message: 'Chưa có trọng tài nào',
                description:
                    'Chưa có trọng tài nào được phân công cho trận đấu này',
                buttonText: 'Phân công trọng tài',
                onButtonPressed: () {
                  context.read<MatchDetailCubit>().generateMatchReferees(
                    roundId: match.roundId!,
                    matchId: match.matchId!,
                  );
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: referees!.length,
                separatorBuilder: (context, index) => Divider(height: 16.sp),
                itemBuilder: (context, index) {
                  final referee = referees![index];
                  return _buildRefereeItem(context, referee);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefereeItem(
    BuildContext context,
    MatchRefereeDetailEntity referee,
  ) {
    final roleIcon =
        referee.role == RefereeType.main ? Icons.sports : Icons.table_chart;

    return Row(
      children: [
        Container(
          width: 40.sp,
          height: 40.sp,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(roleIcon, color: AppColors.primary, size: 24.sp),
        ),
        SizedBox(width: 12.sp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                referee.refereeName ?? 'Không có tên',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                referee.role?.toText() ?? '',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
          onPressed: () {
            _showDeleteRefereeDialog(context, referee);
          },
        ),
      ],
    );
  }

  void _showDeleteRefereeDialog(
    BuildContext context,
    MatchRefereeDetailEntity referee,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa trọng tài'),
            content: Text(
              'Bạn có chắc chắn muốn xóa trọng tài ${referee.refereeName} khỏi trận đấu này?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (referee.refereeId != null) {
                    context.read<MatchDetailCubit>().deleteMatchReferee(
                      referee.refereeId.toString(),
                    );
                  }
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
