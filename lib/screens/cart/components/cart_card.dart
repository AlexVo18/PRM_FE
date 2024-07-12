import 'package:flutter/material.dart';
import 'package:shop_app/constants/constants.dart';

import '../../../models/Cart.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  final Cart cart;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final lego = cart.lego;

    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: lego.image.isNotEmpty
                  ? Image.network(
                      lego.image[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lego.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            Text(
              "\$${cart.lego.price}",
              style: const TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onDecrement,
                ),
                Text(
                  cart.numOfItem.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onIncrement,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
