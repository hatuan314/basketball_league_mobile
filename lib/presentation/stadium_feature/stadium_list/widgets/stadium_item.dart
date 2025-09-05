import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StadiumItem extends StatelessWidget {
  final StadiumModel stadium;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StadiumItem({
    Key? key,
    required this.stadium,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.r),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    stadium.name ?? 'Không có tên',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.r),
                _buildCapacityBadge(),
              ],
            ),
            SizedBox(height: 8.r),
            _buildInfoRow(Icons.location_on, stadium.address ?? 'Không có địa chỉ'),
            SizedBox(height: 4.r),
            _buildInfoRow(Icons.attach_money, '${stadium.ticketPrice ?? 0} VNĐ/vé'),
            SizedBox(height: 8.r),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                  tooltip: 'Chỉnh sửa',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Xóa',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        '${stadium.capacity ?? 0} chỗ ngồi',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: Colors.grey),
        SizedBox(width: 8.r),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
