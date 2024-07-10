import 'package:shop_app/models/LegoDetail.dart';

class Cart {
  final LegoDetail lego;
  int numOfItem;

  Cart({required this.lego, required this.numOfItem});

  Map<String, dynamic> toJson() {
    return {
      'lego': lego.toJson(),
      'numOfItem': numOfItem,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      lego: LegoDetail.fromJson(json['lego']),
      numOfItem: json['numOfItem'],
    );
  }
}

List<Cart> myCart = [];
