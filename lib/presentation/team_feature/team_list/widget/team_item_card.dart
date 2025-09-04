import 'package:baseketball_league_mobile/common/constants/router_name.dart'
    show RouterName;
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_edit/team_edit_screen.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_list/bloc/team_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TeamItemCard extends StatelessWidget {
  final TeamEntity team;
  const TeamItemCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        leading: CircleAvatar(
          backgroundColor: AppColors.orange,
          child: Text(
            team.code?.substring(0, 1) ?? '',
            style: AppStyle.bodyLarge.copyWith(color: Colors.white),
          ),
        ),
        title: Text(
          team.name ?? '',
          style: AppStyle.headline6.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Mã đội: ${team.code}', style: AppStyle.bodySmall),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                context.push(RouterName.teamEdit.toTeamRoute(), extra: team);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(context, team);
              },
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to team detail screen
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TeamEntity team) {
    final teamListCubit = context.read<TeamListCubit>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text('Xác nhận xóa', style: AppStyle.headline6),
            content: Text(
              'Bạn có chắc chắn muốn xóa đội ${team.name}?',
              style: AppStyle.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Hủy', style: AppStyle.buttonMedium),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  if (team.id != null) {
                    await teamListCubit.deleteTeam(team.id!);
                  }
                },
                child: Text(
                  'Xóa',
                  style: AppStyle.buttonMedium.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToEditScreen(BuildContext context, TeamEntity team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: context.read<TeamListCubit>(),
              child: TeamEditScreen(team: team),
            ),
      ),
    );
  }
}
