import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/edit_player/bloc/edit_player_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/edit_player/edit_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPlayerPage extends StatelessWidget {
  final PlayerEntity player;
  
  const EditPlayerPage({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPlayerCubit(
        playerUsecase: sl(),
        player: player,
      ),
      child: EditPlayerScreen(player: player),
    );
  }
}
