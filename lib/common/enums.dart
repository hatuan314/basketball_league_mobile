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
}
