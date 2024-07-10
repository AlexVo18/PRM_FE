import 'package:flutter/material.dart';
import 'package:shop_app/services/AccountRequest.dart';
import 'package:shop_app/utils/preUtils.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants/constants.dart';
import 'package:shop_app/models/Account.dart';

class ProfileUpdateForm extends StatefulWidget {
  const ProfileUpdateForm({super.key});
  @override
  _ProfileUpdateFormState createState() => _ProfileUpdateFormState();
}

class _ProfileUpdateFormState extends State<ProfileUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? email;
  String? name;
  String? phoneNumber;
  String? address;
  Account? _account;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _getAccountDetails();
  }

  Future<void> _getAccountDetails() async {
    _account = await Account.getUser();
    if (_account != null) {
      email = _account!.email;
      name = _account!.displayName;
      phoneNumber = _account!.phoneNumber;
      address = _account!.address;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: email,
                  enabled: false,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kNamelNullError);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kNamelNullError);
                      return "";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: name,
                  onSaved: (newValue) => name = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kNamelNullError);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kNamelNullError);
                      return "";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: phoneNumber,
                  keyboardType: TextInputType.phone,
                  onSaved: (newValue) => phoneNumber = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kPhoneNumberNullError);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kPhoneNumberNullError);
                      return "";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: address,
                  onSaved: (newValue) => address = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kAddressNullError);
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kAddressNullError);
                      return "";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Address",
                    hintText: "Enter your address",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: CustomSurffixIcon(
                        svgIcon: "assets/icons/Location point.svg"),
                  ),
                ),
                FormError(errors: errors),
                const SizedBox(height: 20),
                _isUpdating
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _isUpdating = true;
                            });

                            var accountRequest = AccountRequest();

                            try {
                              var newAccount = Account(
                                email: email!,
                                displayName: name!,
                                address: address!,
                                phoneNumber: phoneNumber!,
                                profilePicUrl: _account!.profilePicUrl,
                                cart: PrefUtil.getCartForCurrentUser(),
                              );
                              await accountRequest.updateAccount(newAccount);
                              Account.saveUser(newAccount);
                              setState(() {
                                _isUpdating = false;
                              });
                              // Handle successful update, e.g., show a success message
                            } catch (e) {
                              setState(() {
                                _isUpdating = false;
                              });
                              // Handle error, e.g., show an error message
                            }
                          }
                        },
                        child: const Text("Update"),
                      ),
              ],
            ),
          );
  }
}
