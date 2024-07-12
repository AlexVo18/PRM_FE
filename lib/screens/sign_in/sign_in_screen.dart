import 'package:flutter/material.dart';

import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: const SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  SignForm(),
                  SizedBox(height: 16),
                  SizedBox(height: 20),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
