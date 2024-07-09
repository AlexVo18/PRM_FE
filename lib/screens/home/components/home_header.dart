import 'package:flutter/material.dart';
import 'package:shop_app/screens/search/search_screen.dart';

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
          Expanded(child: SearchField(
            onSearch: (keyword) {
              Navigator.pushNamed(
                context,
                SearchScreen.routeName,
                arguments: SearchArguments(keyword: keyword),
              );
            },
          )),
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
