import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'player_card.dart';

class PlayerListview extends StatefulWidget {
  final List<PlayerEntity> players;
  const PlayerListview({Key? key, required this.players}) : super(key: key);

  @override
  State<PlayerListview> createState() => _PlayerListviewState();
}

class _PlayerListviewState extends State<PlayerListview> {
  @override
  Widget build(BuildContext context) {
    if (widget.players.isEmpty) {
      return EmptyWidget(
        message: 'Chưa có cầu thủ nào',
        description: 'Hãy thêm cầu thủ mới bằng nút + bên dưới',
        buttonText: 'Tạo ngẫu nhiên',
        onButtonPressed: () {
          context.read<PlayerListCubit>().createRandomGeneratedPlayerList();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PlayerListCubit>().initial();
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: widget.players.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final player = widget.players[index];
          return PlayerCard(player: player);
        },
      ),
    );
    ;
  }
}
