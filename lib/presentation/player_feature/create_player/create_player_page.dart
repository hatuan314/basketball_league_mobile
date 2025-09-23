import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/create_player/bloc/create_player_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/create_player/create_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePlayerPage extends StatelessWidget {
  const CreatePlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreatePlayerCubit>(),
      child: const CreatePlayerScreen(),
    );
  }
}
