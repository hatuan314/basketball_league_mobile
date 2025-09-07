enum RefereeType {
  main,
  assistant,
  table,
  unknown;

  static RefereeType fromString(String name) {
    if (name.toLowerCase() == 'main') return main;
    if (name.toLowerCase() == 'assistant') return assistant;
    if (name.toLowerCase() == 'table') return table;
    return unknown;
  }

  String toString() {
    if (this == main) return 'MAIN';
    if (this == assistant) return 'ASSISTANT';
    if (this == table) return 'TABLE';
    return 'UNKNOWN';
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
