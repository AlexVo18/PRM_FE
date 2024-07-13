import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/services/legoRequest.dart';
import 'package:shop_app/services/themeRequest.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LegoRequest request = LegoRequest();
  final ThemeRequest themeRequest = ThemeRequest();

  List<Lego>? legoList;
  List<Lego>? filteredLegoList;
  bool _isLoading = true;
  bool _isAscending = true;
  late String keyword;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SearchArguments args =
        ModalRoute.of(context)!.settings.arguments as SearchArguments;
    keyword = args.keyword;
    _fetchData(keyword);
  }

  Future<void> _fetchData(String keyword) async {
    try {
      final fetchedLegoList = await request.fetchSearchList(keyword);
      setState(() {
        legoList = fetchedLegoList;
        filteredLegoList = List.from(fetchedLegoList ?? []);
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
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
        title: const Text("Found Products"),
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

class SearchArguments {
  final String keyword;

  SearchArguments({required this.keyword});
}
