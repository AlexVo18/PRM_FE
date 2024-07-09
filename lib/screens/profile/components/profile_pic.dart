import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/Account.dart';
import 'package:shop_app/services/AccountRequest.dart';
import 'package:shop_app/services/firebaseStorage.dart';
import 'package:shop_app/utils.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Account? _account;
  Future<void>? _futureAccount;
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _futureAccount = _getAccountDetails();
  }

  Future<void> _getAccountDetails() async {
    _account = await Account.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: FutureBuilder<void>(
        future: _futureAccount,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile picture'));
          } else {
            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: _isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show spinner while loading
                      : FadeInImage.assetNetwork(
                          placeholder:
                              'assets/images/avatar.png', // Placeholder image
                          image: _account!
                              .profilePicUrl, // Replace with your network image URL
                          fit: BoxFit.cover, // Adjust as needed
                        ),
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFFF5F6F9),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Start loading
                        });

                        Uint8List img = await pickImage(ImageSource.gallery);

                        StoreData storeData = StoreData();
                        String? url = await storeData.updateImageToFirebase(
                            _account!.email, img);

                        AccountRequest accountRequest = AccountRequest();

                        await accountRequest.uploadAvatarImage(
                            _account!.email, url!);

                        Account updatedAccount = await accountRequest
                            .getAccountDetail(_account!.email);

                        if (updatedAccount != null) {
                          Account.saveUser(updatedAccount);
                        }

                        setState(() {
                          _account = updatedAccount; // Update local state
                          _isLoading = false; // End loading
                        });
                      },
                      child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
