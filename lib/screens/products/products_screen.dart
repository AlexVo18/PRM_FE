import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/services/legoRequest.dart';

import '../../main.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: legoList!.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
            ),
    );
  }
}
