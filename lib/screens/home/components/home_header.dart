import 'package:flutter/material.dart';

import '../../cart/cart_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import '../../cart/components/state_management.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
          ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, child) {
              return IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem: count,
                press: () => Navigator.pushNamed(context, CartScreen.routeName),
              );
            },
          ),
          const SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
        ],
      ),
    );
  }
}
