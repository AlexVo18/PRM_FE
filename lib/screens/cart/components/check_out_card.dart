import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Billing.dart';
import 'package:shop_app/models/BillingDetail.dart';
import 'package:shop_app/payment.dart';
import 'package:shop_app/provider/CartProvider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
    required this.myCart,
    required this.onClearCart,
  }) : super(key: key);

  final List<Cart> myCart;
  final VoidCallback onClearCart;

  void _showCartDialog(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cart Contents"),
          content: SingleChildScrollView(
            child: ListBody(
              children: myCart.map((cart) {
                return ListTile(
                  title: Text(cart.lego.name),
                  subtitle: Text("Quantity: ${cart.numOfItem}"),
                  trailing: Text("\$${(cart.lego.price * cart.numOfItem).toStringAsFixed(2)}"),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save to billing and billing detail
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? email = prefs.getString('userEmail');
                dynamic result;
                if (email != null) {
                  result = await cartProvider.saveToBilling(email);
                } else {
                  print("Email is null.");
                }
                final Billing billing = result['billing'];
                final List<BillingDetail> billingDetails = result['billingDetails'];
                Navigator.of(context).pop();
                _showBillingDialog(context, billing, billingDetails);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showBillingDialog(BuildContext context, Billing billing, List<BillingDetail> billingDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Billing Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Account email: ${billing.accountEmail}"),
                Text("Billing ID: ${billing.id}"),
                Text("Total Price: \$${billing.totalPrice.toStringAsFixed(2)}"),
                Text("Status: ${billing.status}"),
                const SizedBox(height: 16),
                const Text("Billing Details:"),
                ...billingDetails.map((detail) {
                  return ListTile(
                    title: Text("Lego ID: ${detail.legoId}"),
                    subtitle: Text("Quantity: ${detail.quantity}"),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                initPaymentSheet(context, billing.accountEmail, billing);
                try {
                  await Stripe.instance.presentPaymentSheet();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Payment Done",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ));

                  // setState(() {
                  //   bool hasDonated = true;
                  // });
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Payment Failed",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  final String selectedCurrency = 'USD';

  Future<void> initPaymentSheet(BuildContext context, String email, Billing billing) async {
    try {
      final data = await createPaymentIntent(
        totalAmount: billing.totalPrice.toString(),
        payDate: DateTime.now(),
        currency: selectedCurrency,
      );



      // if (data != null) {
      //   await Stripe.instance.initPaymentSheet(
      //     paymentSheetParameters: SetupPaymentSheetParameters(
      //       merchantDisplayName: 'Lego Company (Group 3 division)',
      //       paymentIntentClientSecret: data['client_secret'],
      //       customerEphemeralKeySecret: data['ephemeralKey'],
      //       customerId: data['id'],
      //       style: ThemeMode.dark,
      //     ),
      //   );
      // } else {
      //   throw Exception('Incomplete or null data returned from createPaymentIntent');
      // }
      if (data != null) {
        var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US",
          currencyCode: "USD",
          testEnv: true,
        );
        Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: data['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Lego Company (Group 3 division)',
              googlePay: gpay,
            )
        );
      }

    } catch (e) {
      print('Payment sheet failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }




  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;

    for (var cart in myCart) {
      totalPrice += cart.lego.price * cart.numOfItem;
    }

    String formattedTotalPrice = totalPrice.toStringAsFixed(2);

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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      children: [
                        TextSpan(
                          text: "\$$formattedTotalPrice",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showCartDialog(context),
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
