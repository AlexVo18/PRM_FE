import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
    required this.myCart,
    required this.onClearCart,
  }) : super(key: key);

  final List<Cart> myCart;
  final VoidCallback onClearCart;

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;

    for (var cart in myCart) {
      totalPrice += cart.lego.price * cart.numOfItem;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       height: 40,
            //       width: 40,
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF5F6F9),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: SvgPicture.asset("assets/icons/receipt.svg"),
            //     ),
            //     const Spacer(),
            //     const Text("Add voucher code"),
            //     const SizedBox(width: 8),
            //     const Icon(
            //       Icons.arrow_forward_ios,
            //       size: 12,
            //       color: kTextColor,
            //     )
            //   ],
            // ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      children: [
                        TextSpan(
                          text: "\$$totalPrice",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Check Out"),
                  ),
                ),
                const SizedBox(width: 16),
                if (myCart.isNotEmpty) // Condition to display the trash button
                  IconButton(
                    onPressed: onClearCart,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
