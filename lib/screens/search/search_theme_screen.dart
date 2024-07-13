import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/services/legoRequest.dart';

class SearchThemeScreen extends StatefulWidget {
  static String routeName = "/searchThemedLego";

  const SearchThemeScreen({super.key});

  @override
  _SearchThemeScreenState createState() => _SearchThemeScreenState();
}

class _SearchThemeScreenState extends State<SearchThemeScreen> {
  final LegoRequest request = LegoRequest();
  List<Lego>? legoList;
  List<Lego>? filteredLegoList;
  bool _isLoading = true;
  bool _isAscending = true;
  late String themeName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SearchThemeArguments args =
        ModalRoute.of(context)!.settings.arguments as SearchThemeArguments;
    themeName = args.themeName;
    _fetchSearchList(args.themeid);
  }

  Future<void> _fetchSearchList(int themeid) async {
    try {
      final fetchedLegoList = await request.fetchThemedLegoList(themeid);
      setState(() {
        legoList = fetchedLegoList;
        filteredLegoList = List.from(fetchedLegoList ?? []);
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching Lego list: $error');
    }
  }

  void _sortLegoList() {
    setState(() {
      filteredLegoList!.sort((a, b) => _isAscending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      _isAscending = !_isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(themeName + " Legos"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _sortLegoList,
                            child: Row(
                              children: [
                                const Text("Price"),
                                Icon(_isAscending
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          filteredLegoList == null || filteredLegoList!.isEmpty
                              ? const Center(
                                  child: Text("No product available"),
                                )
                              : GridView.builder(
                                  itemCount: filteredLegoList!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 0.7,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 16,
                                  ),
                                  itemBuilder: (context, index) => ProductCard(
                                    product: filteredLegoList![index],
                                    onPress: () => Navigator.pushNamed(
                                      context,
                                      DetailsScreen.routeName,
                                      arguments: ProductDetailsArguments(
                                          id: filteredLegoList![index].id),
                                    ),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class SearchThemeArguments {
  final int themeid;
  final String themeName;

  SearchThemeArguments({required this.themeName, required this.themeid});
}
