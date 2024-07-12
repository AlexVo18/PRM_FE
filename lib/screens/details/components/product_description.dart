import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/LegoDetail.dart';
import 'package:shop_app/screens/search/search_theme_screen.dart';

import '../../../constants/constants.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription(
      {Key? key, required this.product, this.pressOnSeeMore})
      : super(key: key);

  final LegoDetail product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '\$${product.price.toString()}',
                    maxLines: 1,
                    style: const TextStyle(color: kPrimaryColor, fontSize: 20),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    // : const Color(0xFFFFE6E6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Heart Icon_2.svg",
                    colorFilter: const ColorFilter.mode(
                        Color(0xFFDBDEE4),
                        // : const Color(0xFFFF4848),
                        BlendMode.srcIn),
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            product.description,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Wrap(
            spacing: 10, // Horizontal space between buttons
            children: [
              ...product.themes.map((theme) {
                return OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SearchThemeScreen.routeName,
                      arguments: SearchThemeArguments(
                        themeName: theme.name,
                        themeid: theme.id,
                      ),
                    ); // Call function with theme name
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: kPrimaryColor),
                  ),
                  child: Text(
                    theme.name,
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                      child: SvgPicture.asset(
                    "assets/icons/birthday.svg",
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF8e8e8e), BlendMode.srcIn),
                    height: 36,
                  )),
                  const Text("10+",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Ages")
                ],
              ),
              Column(
                children: [
                  Container(
                      child: SvgPicture.asset("assets/icons/pieces.svg",
                          colorFilter: const ColorFilter.mode(
                              Color(0xFF8e8e8e), BlendMode.srcIn),
                          height: 36)),
                  Text(product.number,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Pieces")
                ],
              ),
              Column(
                children: [
                  Container(
                      child: SvgPicture.asset(
                    "assets/icons/calender.svg",
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF8e8e8e), BlendMode.srcIn),
                    height: 36,
                  )),
                  Text("${product.releaseYear}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Release Year")
                ],
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 20,
        //     vertical: 12,
        //   ),
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: const Row(
        //       children: [
        //         Text(
        //           "See More Detail",
        //           style: TextStyle(
        //               fontWeight: FontWeight.w600, color: kPrimaryColor),
        //         ),
        //         SizedBox(width: 5),
        //         Icon(
        //           Icons.arrow_forward_ios,
        //           size: 12,
        //           color: kPrimaryColor,
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
