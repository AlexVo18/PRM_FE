import 'LegoDetail.dart';

class Cart {
  final LegoDetail lego;
  int numOfItem;

  Cart({required this.lego, required this.numOfItem});
}

List<Cart> myCart = [];
