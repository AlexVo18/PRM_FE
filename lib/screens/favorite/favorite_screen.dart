import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/legoRequest.dart';

import '../details/details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final LegoRequest request = LegoRequest();
  List<Lego>? legoList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLegoList();
  }

  Future<void> _fetchLegoList() async {
    try {
      final fetchedLegoList = await request.fetchLegoList();
      setState(() {
        legoList = fetchedLegoList;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching Lego list: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  "Favorites",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: demoProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) => ProductCard(
                        product: legoList![index],
                        onPress: () => Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments:
                              ProductDetailsArguments(id: legoList![index].id),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
