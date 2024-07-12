import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/chat/chatScreen.dart';
import 'package:shop_app/screens/chat_staff/chatStaffScreen.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'package:shop_app/screens/search/search_screen.dart';
import 'package:shop_app/screens/search/search_theme_screen.dart';
import 'package:shop_app/screens/payment_history/payment_history_screen.dart';

import 'screens/cart/cart_screen.dart';
import 'screens/profile_update/profile_update_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ProfileUpdateScreen.routeName: (context) => const ProfileUpdateScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  SearchThemeScreen.routeName: (context) => const SearchThemeScreen(),
  ChatStaffScreen.routeName: (context) => const ChatStaffScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(
        emailSend: '',
        emailReceive: '',
      ),
  // PaymentHistoryScreen.routeName: (context) => const PaymentHistoryScreen(),
};
