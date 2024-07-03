import "Theme.dart";

class Lego {
  final int id;
  final String name;
  final double price;
  final String image;
  final List<Theme> themes;

  Lego(
      {required this.id,
      required this.name,
      required this.price,
      required this.image,
      required this.themes});

  factory Lego.fromJson(Map<String, dynamic> json) {
    return Lego(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        image: json['image'],
        themes: List<Theme>.from(
            json['themes'].map((theme) => Theme.fromJson(theme))));
  }
}
