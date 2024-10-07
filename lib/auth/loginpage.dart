import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_app/dasboard/dasboard_page.dart';
import 'package:flutter_firebase_app/dasboard/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ValueNotifier userCredential = ValueNotifier('');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  final CollectionReference _userController =
      FirebaseFirestore.instance.collection('user');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: userCredential,
            builder: (context, value, child) {
              return (userCredential.value == '' || userCredential == null)
                  ? Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            height: height,
                            width: width / 2,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/login.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Container(
                              width: width / 3,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height / 10,
                                  ),
                                  Text(
                                    'AMEERA',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: height / 5,
                                  ),
                                  Text('Sign up to AMEERA',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: height / 40,
                                  ),
                                  SizedBox(
                                    height: height / 15,
                                    width: width / 7,
                                    child: Card(
                                      elevation: 5,
                                      child: IconButton(
                                          iconSize: 40,
                                          onPressed: () async {
                                            userCredential.value =
                                                await signInWithGoogle();
                                            if (userCredential.value != '') {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DasboardPages()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            }
                                          },
                                          icon: Row(
                                            children: [
                                              Image.asset('google.jpg'),
                                              Text('Sign up with Google')
                                            ],
                                          )),
                                    ),
                                  ),
                                  SizedBox(height: height / 20),
                                  Text(
                                    'OR',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: height / 40),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: height / 40),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: height / 40),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await signInWithEmailAndPassword();
                                    },
                                    child: Text('Sign in with Email'),
                                  ),
                                  Text(
                                    _errorMessage,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _register();
                                    },
                                    child: Text('Register'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container();
            }));
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      setState(() {
        this.userCredential.value = userCredential;
        _errorMessage = '';
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DasboardPages()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred';
      });
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        this.userCredential.value = userCredential;
        _errorMessage = '';
      });
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DasboardPages()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }
}
