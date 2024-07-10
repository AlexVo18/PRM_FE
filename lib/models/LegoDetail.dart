import "Theme.dart";

class LegoDetail {
  final int id;
  final String name;
  final double price;
  final List<String> image;
  final String description;
  final int releaseYear;
  final String number;
  final List<Theme> themes;

  LegoDetail(
      {required this.id,
      required this.name,
      required this.price,
      required this.image,
      required this.description,
      required this.releaseYear,
      required this.number,
      required this.themes});

  factory LegoDetail.fromJson(Map<String, dynamic> json) {
    return LegoDetail(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        image: List<String>.from(json['image']),
        description: json['description'],
        releaseYear: json['releaseYear'],
        number: json['number'],
        themes: List<Theme>.from(
            json['themes'].map((theme) => Theme.fromJson(theme))));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'releaseYear': releaseYear,
      'number': number,
      'themes': themes.map((theme) => theme.toJson()).toList(),
    };
  }
}
