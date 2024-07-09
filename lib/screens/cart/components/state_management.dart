import 'package:flutter/foundation.dart';
import '../../../models/Cart.dart';

ValueNotifier<int> cartItemCount = ValueNotifier<int>(demoCarts.length);

void updateCartItemCount() {
  cartItemCount.value = demoCarts.length;
}
