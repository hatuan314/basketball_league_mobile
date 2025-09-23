import 'package:baseketball_league_mobile/presentation/player_feature/create_player/bloc/create_player_cubit.dart';
import 'package:baseketball_league_mobile/presentation/player_feature/create_player/bloc/create_player_state.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({Key? key}) : super(key: key);

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _selectedDate;

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
      appBar: AppBar(title: const Text('Thêm cầu thủ mới')),
      body: BlocConsumer<CreatePlayerCubit, CreatePlayerState>(
        listener: (context, state) {
          if (state.status == CreatePlayerStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thêm cầu thủ thành công'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state?.status == CreatePlayerStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CreatePlayerStatus.loading) {
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
        context.read<CreatePlayerCubit>().updatePlayerCode(value);
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
        context.read<CreatePlayerCubit>().updatePlayerName(value);
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
        context.read<CreatePlayerCubit>().updatePlayerDob(picked);
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
        context.read<CreatePlayerCubit>().updatePlayerHeight(value);
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
        context.read<CreatePlayerCubit>().updatePlayerWeight(value);
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<CreatePlayerCubit>().createPlayer();
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        'Thêm cầu thủ',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
