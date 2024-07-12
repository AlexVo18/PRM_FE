import 'package:flutter/foundation.dart';
import '../../../models/Cart.dart';

ValueNotifier<int> cartItemCount = ValueNotifier<int>(myCart.length);

void updateCartItemCount() {
  cartItemCount.value = myCart.length;
}
