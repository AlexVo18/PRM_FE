import 'package:flutter/material.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/Account.dart';
import 'package:shop_app/screens/chat/chatScreen.dart';
import 'package:shop_app/services/AccountRequest.dart';

class ChatStaffScreen extends StatefulWidget {
  static String routeName = "/chat_staff";
  const ChatStaffScreen({super.key});

  @override
  _chatStaffScreenState createState() => _chatStaffScreenState();
}

class _chatStaffScreenState extends State<ChatStaffScreen> {
  late Future<List<Account>> _futureAccounts;

  @override
  void initState() {
    super.initState();
    _futureAccounts = AccountRequest().getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
      ),
      body: FutureBuilder<List<Account>>(
        future: _futureAccounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accounts found'));
          } else {
            final accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(account.profilePicUrl),
                  ),
                  title: Text(account.displayName),
                  subtitle: Text(account.email),
                  onTap: () {
                    // Handle account tap, if needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          emailSend: staffEmail,
                          emailReceive: account.email,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
