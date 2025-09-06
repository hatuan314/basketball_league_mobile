import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamStandingSortButton extends StatelessWidget {
  const TeamStandingSortButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortCriteria>(
      icon: const Icon(Icons.sort),
      onSelected: (SortCriteria criteria) {
        context.read<TeamStandingCubit>().sortTeamStandings(criteria);
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<SortCriteria>>[
            const PopupMenuItem<SortCriteria>(
              value: SortCriteria.points,
              child: Text('Sắp xếp theo điểm'),
            ),
            const PopupMenuItem<SortCriteria>(
              value: SortCriteria.wins,
              child: Text('Sắp xếp theo số trận thắng'),
            ),
            const PopupMenuItem<SortCriteria>(
              value: SortCriteria.pointDifference,
              child: Text('Sắp xếp theo hiệu số'),
            ),
            const PopupMenuItem<SortCriteria>(
              value: SortCriteria.pointsScored,
              child: Text('Sắp xếp theo điểm ghi được'),
            ),
          ],
    );
  }
}
