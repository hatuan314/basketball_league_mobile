import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreTab extends StatelessWidget {
  final MatchDetailEntity match;

  const ScoreTab({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.sp),
      child: MatchScoreCard(
        match: match,
        onUpdateScore: (
          homePoints,
          awayPoints,
          homeFouls,
          awayFouls,
          attendance,
        ) {
          context.read<MatchDetailCubit>().updateMatchScore(
            homePoints: homePoints,
            awayPoints: awayPoints,
            homeFouls: homeFouls,
            awayFouls: awayFouls,
            attendance: attendance,
          );
        },
      ),
    );
  }
}
