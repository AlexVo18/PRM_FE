import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/screens/chat/chatScreen.dart';
import 'package:shop_app/screens/chat_staff/chatStaffScreen.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/map/map_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/models/Account.dart';
import 'package:shop_app/utils/preUtils.dart'; // Import your Account model

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;
  Account? _account; // Variable to hold the current user account

  @override
  void initState() {
    super.initState();
    _account =
        PrefUtil.getCurrentUser(); // Fetch the current user's account details
    setState(() {});
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current user is staff
    bool isStaff = _account?.email == staffEmail;

    // Create pages list conditionally including ChatStaffScreen
    final pages = [
      const HomeScreen(),
      isStaff
          ? const ChatStaffScreen()
          : ChatScreen(
        emailReceive: staffEmail,
        emailSend: _account?.email ??
            '', // Replace with the actual sender's email
      ),
      const MapScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Chat",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.map,
              color: kPrimaryColor,
            ),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Fav",
          ),
        ],
      ),
    );
  }
}
