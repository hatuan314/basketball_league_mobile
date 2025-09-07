import 'package:baseketball_league_mobile/presentation/player_feature/player_list/bloc/player_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/player_list/widgets/player_listview.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({Key? key}) : super(key: key);

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerListCubit>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cầu thủ'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<PlayerListCubit, PlayerListState>(
        builder: (context, state) {
          switch (state.status) {
            case PlayerListStatus.loading:
              return const AppLoading();
            case PlayerListStatus.loaded:
              return PlayerListview(players: state.playerList ?? []);
            case PlayerListStatus.error:
              return AppErrorStateWidget(
                errorMessage: state.errorMessage ?? '',
                onRetry: () => context.read<PlayerListCubit>().initial(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new player
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
