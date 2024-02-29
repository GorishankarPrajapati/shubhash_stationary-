import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shubhash_stationary/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/469.jpg"),
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Register',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        hintText: "Email Address"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter email address";
                      } else if (!value.contains("@")) {
                        return "Invalid email address";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        hintText: "Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter password";
                      } else if (value.length < 8) {
                        return "Enter minimum 8 digit password";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _confirmpassword,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        hintText: "Re-enter password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Re-enter password";
                      } else if (value != _password.text) {
                        return "Password didn't match";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Already Registered ?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()));
                          },
                          child: Text("Login"))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.red,
                          maximumSize:
                              Size(MediaQuery.of(context).size.width, 40),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 40)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signup(_email.text, _password.text);
                        }
                      },
                      child: _isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text("Register")),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<String> signup(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String? uid = FirebaseAuth.instance.currentUser!.uid.toString();
      await _firebaseFirestore.collection("shubhash").doc(uid).set({
        "name": "",
        "inventory_level_pen": "Low",
        "inventory_level_pencils": "Low",
        "inventory_level_books": "Low"
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      return "Signup Sucessfull";
    } catch (e) {
      return e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
