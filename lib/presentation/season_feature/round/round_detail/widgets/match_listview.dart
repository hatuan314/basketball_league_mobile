import 'package:baseketball_league_mobile/domain/match/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/widgets/match_item_card.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchListview extends StatelessWidget {
  final List<MatchDetailEntity> matches;

  const MatchListview({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (matches.isEmpty) {
      return const EmptyWidget(
        message: 'Chưa có trận đấu nào',
        description: 'Nhấn nút + để tạo các trận đấu cho vòng đấu này',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            'Danh sách trận đấu (${matches.length})',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchItemCard(match: match);
          },
        ),
      ],
    );
  }
}
