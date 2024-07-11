import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/LegoDetail.dart';
import 'package:shop_app/models/Billing.dart';
import 'package:shop_app/models/BillingDetail.dart';
import 'package:shop_app/utils/preUtils.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _cart = [];
  ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);
  List<Cart> get cart => _cart;

  set cart(List<Cart> newCart) {
    _cart = newCart;
    cartItemCount.value = _cart.length;
    notifyListeners();
  }

  Future<void> loadCart() async {
    final cart = PrefUtil.getCartForCurrentUser();
    _cart = cart;
    cartItemCount.value = _cart.length;
    notifyListeners();
  }

  Future<void> saveCart() async {
    PrefUtil.saveCartForCurrentUser(_cart);
  }

  void addToCart(LegoDetail lego) {
    bool itemExists = false;
    for (var cartItem in _cart) {
      if (cartItem.lego.id == lego.id) {
        cartItem.numOfItem++;
        itemExists = true;
        break;
      }
    }
    if (!itemExists) {
      _cart.add(Cart(lego: lego, numOfItem: 1));
    }

    cartItemCount.value = _cart.length;
    PrefUtil.saveCartForCurrentUser(_cart);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    cartItemCount.value = _cart.length;
    PrefUtil.saveCartForCurrentUser(_cart);
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _cart[index].numOfItem++;
    PrefUtil.saveCartForCurrentUser(_cart);
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_cart[index].numOfItem > 1) {
      _cart[index].numOfItem--;
      PrefUtil.saveCartForCurrentUser(_cart);
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    cartItemCount.value = _cart.length;
    PrefUtil.saveCartForCurrentUser(_cart);
    notifyListeners();
  }

  Future<void> saveToBilling(String accountEmail) async {
    double totalPrice = 0;
    for (var cart in _cart) {
      totalPrice += cart.lego.price * cart.numOfItem;
    }

    final billing = Billing(
      accountEmail: accountEmail,
      dateCreated: DateTime.now(),
      datePaid: DateTime.now(),
      id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
      status: 1, // Status example
      totalPrice: totalPrice,
    );

    await Billing.saveBilling(billing);

    for (var cart in _cart) {
      final billingDetail = BillingDetail(
        billingId: billing.id,
        id: DateTime.now().millisecondsSinceEpoch + cart.lego.id,
        legoId: cart.lego.id,
        quantity: cart.numOfItem,
      );

      await BillingDetail.saveBillingDetail(billingDetail);
    }

    clearCart();
  }
}
