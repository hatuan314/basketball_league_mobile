import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';

class DateFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final String? Function(String?) validator;
  final IconData prefixIcon;
  final IconData labelIcon;

  const DateFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onDateSelected,
    required this.validator,
    required this.prefixIcon,
    required this.labelIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Icon(
              labelIcon,
              size: 18.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        
        // Date field
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 16.h,
            ),
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.primary,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onTap: () => _selectDate(context),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Xác định các giới hạn cho date picker
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now().subtract(
      const Duration(days: 365),
    ); // 1 năm trước
    DateTime lastDate = DateTime.now().add(
      const Duration(days: 365 * 2),
    ); // 2 năm sau

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      onDateSelected(picked);
    }
  }
}
