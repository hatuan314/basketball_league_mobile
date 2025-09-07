import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:baseketball_league_mobile/domain/usecases/stadium_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StadiumFormScreen extends StatefulWidget {
  final StadiumModel? stadium;
  final bool isEditing;

  const StadiumFormScreen({Key? key, this.stadium, this.isEditing = false})
    : super(key: key);

  @override
  State<StadiumFormScreen> createState() => _StadiumFormScreenState();
}

class _StadiumFormScreenState extends State<StadiumFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController();
  final _ticketPriceController = TextEditingController();

  final StadiumUseCase _stadiumUseCase = sl<StadiumUseCase>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.stadium != null) {
      _nameController.text = widget.stadium!.name ?? '';
      _addressController.text = widget.stadium!.address ?? '';
      _capacityController.text = widget.stadium!.capacity?.toString() ?? '';
      _ticketPriceController.text =
          widget.stadium!.ticketPrice?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _capacityController.dispose();
    _ticketPriceController.dispose();
    super.dispose();
  }

  Future<void> _saveStadium() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final stadium = StadiumModel(
      id: widget.isEditing ? widget.stadium!.id : null,
      name: _nameController.text,
      address: _addressController.text,
      capacity: int.tryParse(_capacityController.text),
      ticketPrice: double.tryParse(_ticketPriceController.text),
    );

    try {
      final result =
          widget.isEditing
              ? await _stadiumUseCase.updateStadium(stadium)
              : await _stadiumUseCase.createStadium(stadium);

      result.fold(
        (exception) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${exception.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        },
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isEditing
                    ? 'Cập nhật sân vận động thành công!'
                    : 'Tạo sân vận động thành công!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Chỉnh sửa sân vận động' : 'Tạo sân vận động mới',
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Tên sân vận động',
                          hint: 'Nhập tên sân vận động',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tên sân vận động';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.r),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Địa chỉ',
                          hint: 'Nhập địa chỉ sân vận động',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập địa chỉ sân vận động';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.r),
                        _buildTextField(
                          controller: _capacityController,
                          label: 'Sức chứa',
                          hint: 'Nhập sức chứa sân vận động',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập sức chứa sân vận động';
                            }
                            final capacity = int.tryParse(value);
                            if (capacity == null || capacity <= 0) {
                              return 'Sức chứa phải là số dương';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.r),
                        _buildTextField(
                          controller: _ticketPriceController,
                          label: 'Giá vé (VNĐ)',
                          hint: 'Nhập giá vé',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập giá vé';
                            }
                            final price = int.tryParse(value);
                            if (price == null || price < 0) {
                              return 'Giá vé không được âm';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32.r),
                        ElevatedButton(
                          onPressed: _saveStadium,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                          ),
                          child: Text(
                            widget.isEditing ? 'Cập nhật' : 'Tạo mới',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
