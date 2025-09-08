import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_referee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefereesTab extends StatelessWidget {
  final MatchDetailEntity match;
  final List<MatchRefereeDetailEntity>? referees;

  const RefereesTab({super.key, required this.match, this.referees});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.sp),
      child: MatchRefereeCard(match: match, referees: referees),
    );
  }
}
