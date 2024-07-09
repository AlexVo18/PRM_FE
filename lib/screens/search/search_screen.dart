import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/services/legoRequest.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LegoRequest request = LegoRequest();
  List<Lego>? legoList;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SearchArguments args =
        ModalRoute.of(context)!.settings.arguments as SearchArguments;
    _fetchSearchList(args.keyword);
  }

  Future<void> _fetchSearchList(String keyword) async {
    try {
      final fetchedLegoList = await request.fetchSearchList(keyword);
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

class SearchArguments {
  final String keyword;

  SearchArguments({required this.keyword});
}
