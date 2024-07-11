import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> createPaymentIntent({
  required String totalAmount,
  required DateTime payDate,
  required String currency,
}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey = 'sk_test_51PbO7LRpGRSEJtbQXEYfr2j83QYaeU7lrqHnPOfvvPku6wjibAMTJDI9BnLxJGhAsQiaCpzRgexuVXlrQ2zlbKaX00mWlVkSvA';

  final int amountInCents = (double.parse(totalAmount) * 100).toInt();

  final body = {
    'amount': amountInCents.toString(),
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Lego Payment at $payDate. Total amount: $totalAmount",
  };

  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );

    print(body);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("Data returned");
      print(json);
      return json;
    } else {
      print("Error in calling payment intent. Status code: ${response.statusCode}");
      print("Response: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Exception caught: $e");
    return null;
  }
}
