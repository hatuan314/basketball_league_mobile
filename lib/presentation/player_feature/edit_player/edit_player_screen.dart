import 'package:baseketball_league_mobile/domain/entities/player_entity.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/edit_player/bloc/edit_player_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/edit_player/bloc/edit_player_state.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EditPlayerScreen extends StatefulWidget {
  final PlayerEntity player;
  
  const EditPlayerScreen({Key? key, required this.player}) : super(key: key);

  @override
  State<EditPlayerScreen> createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends State<EditPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadPlayerData(widget.player);
  }
  
  void _loadPlayerData(PlayerEntity player) {
    _nameController.text = player.fullName ?? '';
    _codeController.text = player.playerCode ?? '';
    if (player.dob != null) {
      _selectedDate = player.dob;
      _dobController.text = DateFormat('dd/MM/yyyy').format(player.dob!);
    }
    _heightController.text = player.height?.toString() ?? '';
    _weightController.text = player.weight?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa cầu thủ'),
      ),
      body: BlocConsumer<EditPlayerCubit, EditPlayerState>(
        listener: (context, state) {
          if (state.status == EditPlayerStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật cầu thủ thành công'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state.status == EditPlayerStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == EditPlayerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPlayerCodeField(),
                    SizedBox(height: 16.h),
                    _buildPlayerNameField(),
                    SizedBox(height: 16.h),
                    _buildDateOfBirthField(),
                    SizedBox(height: 16.h),
                    _buildHeightField(),
                    SizedBox(height: 16.h),
                    _buildWeightField(),
                    SizedBox(height: 32.h),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerCodeField() {
    return AppTextField(
      controller: _codeController,
      labelText: 'Mã cầu thủ',
      hintText: 'Nhập mã cầu thủ',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mã cầu thủ';
        }
        return null;
      },
      onChanged: (value) {
        context.read<EditPlayerCubit>().updatePlayerCode(value);
      },
    );
  }

  Widget _buildPlayerNameField() {
    return AppTextField(
      controller: _nameController,
      labelText: 'Tên cầu thủ',
      hintText: 'Nhập tên cầu thủ',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập tên cầu thủ';
        }
        return null;
      },
      onChanged: (value) {
        context.read<EditPlayerCubit>().updatePlayerName(value);
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return AppTextField(
      controller: _dobController,
      labelText: 'Ngày sinh',
      hintText: 'DD/MM/YYYY',
      readOnly: true,
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () => _selectDate(context),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn ngày sinh';
        }
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
        context.read<EditPlayerCubit>().updatePlayerDob(picked);
      });
    }
  }

  Widget _buildHeightField() {
    return AppTextField(
      controller: _heightController,
      labelText: 'Chiều cao (cm)',
      hintText: 'Nhập chiều cao',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập chiều cao';
        }
        if (int.tryParse(value) == null || int.parse(value) <= 0) {
          return 'Chiều cao phải là số dương';
        }
        return null;
      },
      onChanged: (value) {
        context.read<EditPlayerCubit>().updatePlayerHeight(value);
      },
    );
  }

  Widget _buildWeightField() {
    return AppTextField(
      controller: _weightController,
      labelText: 'Cân nặng (kg)',
      hintText: 'Nhập cân nặng',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập cân nặng';
        }
        if (int.tryParse(value) == null || int.parse(value) <= 0) {
          return 'Cân nặng phải là số dương';
        }
        return null;
      },
      onChanged: (value) {
        context.read<EditPlayerCubit>().updatePlayerWeight(value);
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<EditPlayerCubit>().updatePlayer();
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        backgroundColor: AppColors.orange,
      ),
      child: Text(
        'Cập nhật cầu thủ',
        style: AppStyle.buttonLarge.copyWith(color: AppColors.white),
      ),
    );
  }
}
