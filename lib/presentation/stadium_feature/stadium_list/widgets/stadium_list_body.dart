import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_state.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/widgets/stadium_item.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StadiumListBody extends StatefulWidget {
  final Function() onRefresh;
  const StadiumListBody({super.key, required this.onRefresh});

  @override
  State<StadiumListBody> createState() => _StadiumListBodyState();
}

class _StadiumListBodyState extends State<StadiumListBody> {
  Future<void> _generateRandomStadiums() async {
    // Hiển thị dialog để nhập số lượng
    final TextEditingController countController = TextEditingController(
      text: '5',
    );
    final int? count = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tạo sân vận động ngẫu nhiên'),
          content: TextField(
            controller: countController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Số lượng',
              hintText: 'Nhập số lượng sân vận động cần tạo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final count = int.tryParse(countController.text);
                Navigator.pop(context, count);
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );

    if (count == null || count <= 0) return;

    context.read<StadiumListCubit>().generateRandomStadiums(count);
  }

  void _deleteStadium(int id) {
    context.read<StadiumListCubit>().deleteStadium(id);
  }

  void _showDeleteConfirmation(StadiumModel stadium) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa sân vận động "${stadium.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (stadium.id != null) {
                    _deleteStadium(stadium.id!);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StadiumListCubit, StadiumListState>(
      listener: (context, state) {
        if (state is StadiumTableCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo bảng thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StadiumTableError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tạo bảng: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StadiumDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa sân vận động thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StadiumDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StadiumRandomCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã tạo ${state.stadiums.length} sân vận động ngẫu nhiên',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StadiumRandomError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tạo dữ liệu: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is StadiumListLoading) {
          return AppLoading();
        }

        if (state is StadiumListError) {
          return AppErrorStateWidget(
            errorMessage: state.message,
            onRetry: widget.onRefresh,
          );
        }

        if (state is StadiumListLoaded) {
          if (state.stadiums.isEmpty) {
            return EmptyWidget(
              message: 'Chưa có sân vận động nào',
              description: 'Hãy thêm sân vận động mới hoặc tạo dữ liệu mẫu',
              buttonText: 'Tạo dữ liệu mẫu',
              onButtonPressed: () => _generateRandomStadiums(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => widget.onRefresh(),
            child: ListView.builder(
              padding: EdgeInsets.all(16.sp),
              itemCount: state.stadiums.length,
              itemBuilder: (context, index) {
                final stadium = state.stadiums[index];
                return StadiumItem(
                  stadium: stadium,
                  onEdit:
                      () => context
                          .push(
                            RouterName.stadiumEdit.toStadiumRoute(),
                            extra: {'stadium': stadium, 'isEditing': true},
                          )
                          .then((_) => widget.onRefresh()),
                  onDelete: () => _showDeleteConfirmation(stadium),
                );
              },
            ),
          );
        }

        return EmptyWidget(
          message: 'Chưa có sân vận động nào',
          description: 'Hãy thêm sân vận động mới hoặc tạo dữ liệu mẫu',
          buttonText: 'Tạo dữ liệu mẫu',
          onButtonPressed: () => _generateRandomStadiums(),
        );
      },
    );
  }
}
