import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/ChatMessage.dart';
import 'package:shop_app/models/Account.dart'; // Import your Account model
import 'dart:io';

import 'package:shop_app/services/AccountRequest.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chat";
  final String emailSend;
  final String emailReceive;

  const ChatScreen({
    Key? key,
    required this.emailSend,
    required this.emailReceive,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Account _sendAccount;
  late Account _receiveAccount;
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  late String emailMember;
  String? userEmail;
  bool _hasError = false; // Track if there's an error
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  Future<void> _fetchAccounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var accountRequest = AccountRequest();
      final sendAccountFuture =
          accountRequest.getAccountDetail(widget.emailSend);
      final receiveAccountFuture =
          accountRequest.getAccountDetail(widget.emailReceive);

      final List<Account> accounts =
          await Future.wait([sendAccountFuture, receiveAccountFuture]);

      _sendAccount = accounts[0];
      _receiveAccount = accounts[1];

      // Determine emailMember based on who is staff and who is member
      if (widget.emailSend == staffEmail) {
        emailMember = widget.emailReceive; // EmailReceive is the member
      } else if (widget.emailReceive == staffEmail) {
        emailMember = widget.emailSend; // EmailSend is the member
      } else {
        throw Exception('Invalid chat configuration');
      }

      // Determine userEmail based on current user's email
      userEmail =
          _sendAccount.email; // Assuming sender's email is the user's email

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true; // Set error state to true
        _isLoading = false; // Disable loading indicator
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    final message = ChatMessage(
      emailSend: widget.emailSend,
      emailReceive: widget.emailReceive,
      type: 'text',
      text: text,
      timeSend: DateTime.now(),
    );

    var documentReference = FirebaseFirestore.instance
        .collection('chats')
        .doc(emailMember)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, message.toMap());
    });

    _controller.clear();
    _scrollToBottom();
  }

  Future<void> _sendImage(XFile image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = _storage.ref().child('chat_images').child(fileName);
    final uploadTask = storageRef.putFile(File(image.path));

    final imageUrl = await (await uploadTask).ref.getDownloadURL();

    final message = ChatMessage(
      emailSend: widget.emailSend,
      emailReceive: widget.emailReceive,
      type: 'image',
      imageUrl: imageUrl,
      timeSend: DateTime.now(),
    );

    var documentReference = FirebaseFirestore.instance
        .collection('chats')
        .doc(emailMember)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, message.toMap());
    });

    _scrollToBottom(); // Scroll to bottom after sending image
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _sendImage(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      // Display error message or retry button
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Failed to load chat. Please try again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.emailReceive}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chats')
                        .doc(emailMember)
                        .collection('messages')
                        .orderBy('timeSend')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No messages yet.'));
                      }

                      final messages = snapshot.data!.docs
                          .map((doc) => ChatMessage.fromMap(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isCurrentUser =
                              message.emailSend == widget.emailSend;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: isCurrentUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isCurrentUser)
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        _receiveAccount.profilePicUrl),
                                  ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? kPrimaryColor
                                            : kSecondaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: message.type == 'text'
                                          ? Text(message.text!,
                                              style: TextStyle(
                                                  color: Colors.white))
                                          : Image.network(
                                              message.imageUrl!,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6, // 80% of screen width
                                              fit: BoxFit
                                                  .contain, // Adjust the fit based on your image requirements
                                            ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(message.timeSend),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
