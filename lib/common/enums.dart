enum RefereeType {
  main,
  table,
  unknown;

  static RefereeType fromString(String name) {
    if (name.toLowerCase() == 'main') return main;
    if (name.toLowerCase() == 'table') return table;
    return unknown;
  }

  String toCode() {
    if (this == main) return 'MAIN';
    if (this == table) return 'TABLE';
    return 'UNKNOWN';
  }

  String toText() {
    if (this == main) return 'Trọng tài chính';
    if (this == table) return 'Trọng tài bàn';
    return 'Không xác định';
  }
}

enum PhoneType {
  home,
  work,
  mobile,
  unknown;

  static PhoneType fromString(String name) {
    if (name.toLowerCase() == 'home') return home;
    if (name.toLowerCase() == 'work') return work;
    if (name.toLowerCase() == 'mobile') return mobile;
    return unknown;
  }

  String toString() {
    if (this == home) return 'HOME';
    if (this == work) return 'WORK';
    if (this == mobile) return 'MOBILE';
    return 'UNKNOWN';
  }
}
