import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/profile_update/profile_update_screen.dart';
import 'package:shop_app/screens/payment_history/payment_history_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:toastification/toastification.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Profile",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  {Navigator.pushNamed(context, ProfileUpdateScreen.routeName)},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Payment History",
              icon: "assets/icons/Bill Icon.svg",
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentHistoryScreen(),
                ),
              ),
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                await FirebaseAuth.instance.signOut();
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                  title: const Text("Log out successfully"),
                  alignment: Alignment.topCenter,
                  autoCloseDuration: const Duration(seconds: 3),
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: lowModeShadow,
                );
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
