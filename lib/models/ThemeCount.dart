class ThemeCount {
  final int id;
  final String name;
  final String numOfLegos;

  ThemeCount({required this.id, required this.name, required this.numOfLegos});

  factory ThemeCount.fromJson(Map<String, dynamic> json) {
    return ThemeCount(
        id: json['id'], name: json['name'], numOfLegos: json['numOfLegos']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'numOfLegos': numOfLegos,
    };
  }
}
