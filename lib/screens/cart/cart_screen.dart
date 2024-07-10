import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/CartProvider.dart';

import '../../models/Cart.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _clearCart() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Clear Cart',
      desc: 'Are you sure you want to clear all items from the cart?',
      btnCancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      btnOk: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Provider.of<CartProvider>(context, listen: false).clearCart();
        },
        child: const Text('Ok'),
      ),
    ).show();
  }

  void _incrementQuantity(int index) {
    Provider.of<CartProvider>(context, listen: false).incrementQuantity(index);
  }

  void _decrementQuantity(int index) {
    Provider.of<CartProvider>(context, listen: false).decrementQuantity(index);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final List<Cart> myCart = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            ValueListenableBuilder<int>(
              valueListenable: cartProvider.cartItemCount,
              builder: (context, itemCount, _) => Text(
                "$itemCount items",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: myCart.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(myCart[index].lego.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                Provider.of<CartProvider>(context, listen: false)
                    .removeFromCart(index);
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    SvgPicture.asset("assets/icons/Trash.svg"),
                  ],
                ),
              ),
              child: CartCard(
                cart: myCart[index],
                onIncrement: () => _incrementQuantity(index),
                onDecrement: () => _decrementQuantity(index),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckoutCard(myCart: myCart, onClearCart: _clearCart),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
