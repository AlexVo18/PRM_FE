import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/Theme.dart' as LegoTheme;
import 'package:shop_app/services/legoRequest.dart';
import 'package:shop_app/services/themeRequest.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final LegoRequest legoRequest = LegoRequest();
  final ThemeRequest themeRequest = ThemeRequest();

  List<Lego>? legoList;
  List<LegoTheme.Theme>? themeList;
  List<Lego>? filteredLegoList;
  bool _isLoading = true;
  bool _isAscending = true;
  String? _selectedTheme = "All"; // Initialize with "All" theme

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedLegoList = await legoRequest.fetchLegoList();
      final fetchedThemeList = await themeRequest.fetchThemeList();
      setState(() {
        legoList = fetchedLegoList;
        filteredLegoList = fetchedLegoList;
        themeList = fetchedThemeList;
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

  void _filterByTheme(String? theme) {
    setState(() {
      _selectedTheme = theme;
      if (theme == null || theme == "All") {
        filteredLegoList = legoList;
      } else {
        filteredLegoList = legoList!.where((lego) {
          return lego.themes.any((t) => t.name == theme);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Selection"),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                DropdownButton<String>(
                                  menuMaxHeight: 200,
                                  value: _selectedTheme,
                                  onChanged: _filterByTheme,
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: "All",
                                      child: Text("All"),
                                    ),
                                    ...themeList!.map((theme) {
                                      return DropdownMenuItem<String>(
                                        value: theme.name,
                                        child: Text(theme.name),
                                      );
                                    }).toList(),
                                  ],
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  dropdownColor: Colors.white,
                                  underline: const SizedBox(),
                                ),
                              ],
                            ),
                          ),
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
