import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/LegoDetail.dart';
import 'package:shop_app/models/Billing.dart';
import 'package:shop_app/models/BillingDetail.dart';
import 'package:shop_app/services/BillingRequest.dart';
import 'package:shop_app/utils/preUtils.dart';
import 'dart:math';

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

  Future<Map<String, dynamic>> saveToBilling(String accountEmail) async {
    double totalPrice = 0;
    for (var cart in _cart) {
      totalPrice += cart.lego.price * cart.numOfItem;
    }
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);

    int generateRandomId() {
      Random random = Random();
      return random.nextInt(9001) + 1000; // Generates a random number between 2000 and 7000
    }

    Future<int> generateUniqueRandomId() async {
      var billingRequest = BillingRequest();
      int id = generateRandomId();

      try {
        Billing? billing = await billingRequest.getBillingByID(id);
        while (billing != null) {
          print('ID $id already exists');
          id = generateRandomId();
          billing = await billingRequest.getBillingByID(id);
        }
      } catch (e) {
        print('Error fetching billing: $e');
        throw Exception('Failed to check existing billing ID');
      }

      return id;
    }


    final billing = Billing(
      accountEmail: accountEmail,
      dateCreated: DateTime.now(),
      datePaid: DateTime.now(),
      id: generateRandomId(),
      status: 1,
      totalPrice: totalPrice,
    );

    await Billing.saveBilling(billing);

    List<BillingDetail> billingDetails = [];
    for (var cart in _cart) {
      final billingDetail = BillingDetail(
        billingId: billing.id,
        id: generateRandomId(),
        legoId: cart.lego.id,
        quantity: cart.numOfItem,
      );

      await BillingDetail.saveBillingDetail(billingDetail);
      billingDetails.add(billingDetail);
    }

    clearCart();

    return {'billing': billing, 'billingDetails': billingDetails};
  }
}
