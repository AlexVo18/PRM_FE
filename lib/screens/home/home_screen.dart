import 'package:flutter/material.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/ThemeCount.dart';
import 'package:shop_app/services/legoRequest.dart';
import 'package:shop_app/services/themeRequest.dart';
import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LegoRequest request = LegoRequest();
  final ThemeRequest themeRequest = ThemeRequest();

  late List<ThemeCount> themeCounts;
  List<Lego>? recentList;
  List<Lego>? popularList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLegoList();
  }

  Future<void> _fetchLegoList() async {
    try {
      final fetchedRecentList = await request.fetchRecentLegoList();
      final fetchedPopularList = await request.fetchPopularLegoList();
      final fetchedThemeCounts = await themeRequest.fetchThemeCount();
      setState(() {
        recentList = fetchedRecentList;
        popularList = fetchedPopularList;
        themeCounts = fetchedThemeCounts;
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
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    const HomeHeader(),
                    const DiscountBanner(),
                    const Categories(),
                    SpecialOffers(themeCounts: themeCounts),
                    const SizedBox(height: 20),
                    PopularProducts(
                        legoList: popularList, title: "Popular Products"),
                    PopularProducts(
                        legoList: recentList, title: "Recently Added"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
