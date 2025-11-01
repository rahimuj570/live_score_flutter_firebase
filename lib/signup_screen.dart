import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_score_app2/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Football Live Score"),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_football, size: 100),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: emailTEC,
                  decoration: InputDecoration(label: Text('Email')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Must Input Email";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: passwordTEC,
                  decoration: InputDecoration(label: Text('Password')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Must Input Password";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(label: Text('Confirm Password')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Must Input Password";
                    } else if (passwordTEC.text != value) {
                      return "Password is not matched";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: !processing,
                  replacement: CircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(),
                    ),
                    child: Text('Sign up'),
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    text: 'Already have an account?',
                    children: [
                      TextSpan(
                        children: [
                          TextSpan(
                            text: ' Click Here',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    processing = true;
    setState(() {});
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailTEC.text,
            password: passwordTEC.text,
          );
      if (credential.user?.uid == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('failed to register')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('successfully registered'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email.')),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The email address is invalid.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An unknown Firebase error occurred.'),
          ),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      processing = false;
      setState(() {});
    }
  }
}
