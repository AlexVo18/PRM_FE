import 'package:flutter/material.dart';
import 'package:shop_app/models/ThemeCount.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'package:shop_app/screens/search/search_theme_screen.dart';
import 'package:shop_app/services/themeRequest.dart';

import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({super.key, required this.themeCounts});

  final List<ThemeCount>? themeCounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Exclusive Lego Themes",
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image:
                    "https://www.lego.com/cdn/cs/set/assets/blt475f2f3ee85daf96/StarWars-202405-Theme-Preview.jpg?fit=bounds&format=webply&quality=80&width=420&height=200&dpr=1.5",
                category: "Star Wars",
                numOfBrands: int.parse(themeCounts
                    !.firstWhere((theme) => theme.name == "Star Wars")
                    .numOfLegos),
                press: () {
                  Navigator.pushNamed(
                    context,
                    SearchThemeScreen.routeName,
                    arguments: SearchThemeArguments(
                      themeName: "Star Wars",
                      themeid: 4,
                    ),
                  );
                },
              ),
              SpecialOfferCard(
                image:
                    "https://www.lego.com/cdn/cs/set/assets/blt59b9f415e2986b90/HarryPotter-202401-Theme-Preview.jpg?fit=bounds&format=webply&quality=80&width=420&height=200&dpr=1.5",
                category: "Harry Potter",
                numOfBrands: int.parse(themeCounts
                    !.firstWhere((theme) => theme.name == "Harry Potter")
                    .numOfLegos),
                press: () {
                  Navigator.pushNamed(
                    context,
                    SearchThemeScreen.routeName,
                    arguments: SearchThemeArguments(
                      themeName: "Harry Potter",
                      themeid: 7,
                    ),
                  );
                },
              ),
              SpecialOfferCard(
                image:
                    "https://www.lego.com/cdn/cs/set/assets/bltd51eec95d3b791a9/Batman-202401-Theme-Preview.jpg?fit=bounds&format=webply&quality=80&width=420&height=200&dpr=1.5",
                category: "DC",
                numOfBrands: int.parse(themeCounts
                    !.firstWhere((theme) => theme.name == "DC")
                    .numOfLegos),
                press: () {
                  Navigator.pushNamed(
                    context,
                    SearchThemeScreen.routeName,
                    arguments: SearchThemeArguments(
                      themeName: "DC",
                      themeid: 6,
                    ),
                  );
                },
              ),
              SpecialOfferCard(
                image:
                    "https://www.lego.com/cdn/cs/set/assets/bltf35103c1ce3a5953/Minecraft-202401-Theme-Preview.jpg?fit=bounds&format=webply&quality=80&width=420&height=200&dpr=1.5",
                category: "Minecraft",
                numOfBrands: int.parse(themeCounts
                    !.firstWhere((theme) => theme.name == "Minecraft")
                    .numOfLegos),
                press: () {
                  Navigator.pushNamed(
                    context,
                    SearchThemeScreen.routeName,
                    arguments: SearchThemeArguments(
                      themeName: "Minecraft",
                      themeid: 3,
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Brands")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
