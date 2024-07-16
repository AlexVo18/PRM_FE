import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/LegoDetail.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/services/legoRequest.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  LegoDetail? product;
  bool _isLoading = true;
  List<Lego>? legoList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    _fetchLegoDetail(args.id);
    _fetchLegoList();
  }

  Future<void> _fetchLegoDetail(int id) async {
    try {
      final fetchedLegoDetail = await LegoRequest().fetchLegoDetail(id);
      setState(() {
        product = fetchedLegoDetail;
        _isLoading = false;
      });
      print('Fetched Lego detail: $fetchedLegoDetail');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching Lego detail: $error');
    }
  }

  Future<void> _fetchLegoList() async {
    try {
      final fetchedLegoList = await LegoRequest().fetchRecentLegoList();
      setState(() {
        legoList = fetchedLegoList;
        _isLoading = false;
      });
      print('Fetched Lego list: $fetchedLegoList');
    } catch (error) {
      print('Error fetching Lego list: $error');
    }
  }

  void _addToCart(LegoDetail lego) {
    print('Lego: ${lego.name}');
    Provider.of<CartProvider>(context, listen: false).addToCart(lego);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Item Added to Cart',
      desc:
          'The LEGO set has been successfully added to your cart. Continue shopping or proceed to checkout.',
      showCloseIcon: true,
      btnCancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kSecondaryColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Continue'),
      ),
      btnOk: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, CartScreen.routeName);
        },
        child: const Text('Your cart'),
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text(
                      "4.7",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset("assets/icons/Star Icon.svg"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null || legoList == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    ProductImages(product: product!),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ProductDescription(
                            product: product!,
                            pressOnSeeMore: () {},
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    TopRoundedContainer(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Other Products",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: legoList!.length,
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
                                    arguments: ProductDetailsArguments(
                                        id: legoList![index].id),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                if (product != null) {
                  _addToCart(product!);
                }
              },
              child: const Text("Add To Cart"),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final int id;

  ProductDetailsArguments({required this.id});
}
