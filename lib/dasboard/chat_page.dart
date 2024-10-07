import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String Email = '';
  String UserId = '';

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (Email.isNotEmpty && UserId.isNotEmpty)
            ? Tawk(
                directChatLink:
                    'https://tawk.to/chat/67037683256fb1049b1e40d2/1i9iodsjv',
                visitor: TawkVisitor(
                  name: Email,
                  email: Email,
                ),
              )
            : CircularProgressIndicator());
  }

  void getEmail() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        UserId = user.uid;
        Email = user.email!;
      });
    }
  }
}
