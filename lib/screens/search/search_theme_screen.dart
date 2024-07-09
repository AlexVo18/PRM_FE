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
  bool _isLoading = true;
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
        title: Text(themeName + " Legos"),
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

class SearchThemeArguments {
  final int themeid;
  final String themeName;

  SearchThemeArguments({required this.themeName, required this.themeid});
}
