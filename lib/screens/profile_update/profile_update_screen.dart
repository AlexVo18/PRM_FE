import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import 'components/profile_update_form.dart';

class ProfileUpdateScreen extends StatelessWidget {
  static String routeName = "/profile_update";

  const ProfileUpdateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text("Edit Profile", style: headingStyle),
                  Text(
                    "Edit your profile detail",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ProfileUpdateForm(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
