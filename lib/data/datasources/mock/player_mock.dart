import 'dart:math';

import 'package:baseketball_league_mobile/data/models/player_model.dart';

/// Danh sách 100 cầu thủ mock để sử dụng trong quá trình phát triển
/// Mỗi cầu thủ có thông tin đa dạng về chiều cao, cân nặng và ngày sinh
final List<PlayerModel> mockPlayerList = _generateMockPlayers();

/// Danh sách họ phổ biến ở Việt Nam
const List<String> _lastNames = [
  'Nguyễn',
  'Trần',
  'Lê',
  'Phạm',
  'Hoàng',
  'Huỳnh',
  'Phan',
  'Vũ',
  'Võ',
  'Đặng',
  'Bùi',
  'Đỗ',
  'Hồ',
  'Ngô',
  'Dương',
  'Lý',
  'Đinh',
  'Trịnh',
  'Đoàn',
  'Mai',
  'Lương',
  'Trương',
  'Cao',
  'Châu',
  'Đào',
  'Tạ',
  'Lâm',
  'Triệu',
  'Bạch',
];

/// Danh sách tên phổ biến ở Việt Nam
const List<String> _firstNames = [
  'An',
  'Anh',
  'Bảo',
  'Công',
  'Cường',
  'Đạt',
  'Đức',
  'Dũng',
  'Dương',
  'Hải',
  'Hiếu',
  'Hoàng',
  'Hùng',
  'Huy',
  'Khoa',
  'Khôi',
  'Kiên',
  'Lâm',
  'Long',
  'Minh',
  'Nam',
  'Nghĩa',
  'Nhân',
  'Phong',
  'Phúc',
  'Quân',
  'Quang',
  'Sơn',
  'Thành',
  'Thiện',
  'Thịnh',
  'Thuận',
  'Toàn',
  'Trung',
  'Tuấn',
  'Tùng',
  'Việt',
  'Vinh',
  'Vũ',
  'Xuân',
];

/// Danh sách tên đệm phổ biến ở Việt Nam
const List<String> _middleNames = [
  'Văn',
  'Đức',
  'Hữu',
  'Quang',
  'Minh',
  'Hoàng',
  'Công',
  'Đình',
  'Xuân',
  'Thành',
  'Huy',
  'Bá',
  'Quốc',
  'Anh',
  'Hải',
  'Trọng',
  'Tuấn',
  'Mạnh',
  'Đăng',
  'Thanh',
  'Thế',
  'Gia',
  'Thiên',
  'Khắc',
  'Duy',
  'Ngọc',
  'Hồng',
  'Thị',
  'Kim',
  'Thùy',
];

/// Tạo danh sách 100 cầu thủ mock với thông tin ngẫu nhiên
List<PlayerModel> _generateMockPlayers() {
  final random = Random();
  final List<PlayerModel> players = [];

  for (int i = 1; i <= 200; i++) {
    // Tạo mã cầu thủ theo định dạng PLxxx (PL001, PL002, ...)
    final playerCode = 'PL${i.toString().padLeft(3, '0')}';

    // Tạo họ tên đầy đủ
    final lastName = _lastNames[random.nextInt(_lastNames.length)];
    final middleName = _middleNames[random.nextInt(_middleNames.length)];
    final firstName = _firstNames[random.nextInt(_firstNames.length)];
    final fullName = '$lastName $middleName $firstName';

    // Tạo ngày sinh trong khoảng từ 18-35 tuổi
    final currentYear = DateTime.now().year;
    final birthYear = currentYear - 18 - random.nextInt(18); // 18-35 tuổi
    final birthMonth = 1 + random.nextInt(12); // 1-12
    final daysInMonth = _getDaysInMonth(birthYear, birthMonth);
    final birthDay = 1 + random.nextInt(daysInMonth); // 1-28/29/30/31
    final dob = DateTime(birthYear, birthMonth, birthDay);

    // Tạo chiều cao trong khoảng 170-215 cm
    final height = 170 + random.nextInt(46); // 170-215 cm

    // Tạo cân nặng dựa trên chiều cao
    // Công thức đơn giản: weight = (height - 100) + random(-10, +20)
    final baseWeight = height - 100;
    final weightVariation = -10 + random.nextInt(31); // -10 đến +20
    final weight = baseWeight + weightVariation;

    players.add(
      PlayerModel(
        playerCode: playerCode,
        fullName: fullName,
        dob: dob,
        height: height,
        weight: weight,
      ),
    );
  }

  return players;
}

/// Hàm hỗ trợ lấy số ngày trong tháng
int _getDaysInMonth(int year, int month) {
  if (month == 2) {
    // Kiểm tra năm nhuận
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return 29;
    }
    return 28;
  }
  if ([4, 6, 9, 11].contains(month)) {
    return 30;
  }
  return 31;
}
