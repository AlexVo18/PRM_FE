class Theme {
  final int id;
  final String name;

  Theme({required this.id, required this.name});

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
