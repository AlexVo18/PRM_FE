import 'package:flutter/material.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/services/legoRequest.dart';
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
                    const SpecialOffers(),
                    const SizedBox(height: 20),
                    PopularProducts(legoList: legoList),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
