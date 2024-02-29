import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shubhash_stationary/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedPen = 'Low';
  String _selectedPencils = 'Low';
  String _selectedBooks = 'Low';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String _notificationStatus = '';

  // Function to update inventory level in Firestore
  Future<void> updateInventoryLevel(String item, String level) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid.toString();
      await _firebaseFirestore.collection("shubhash").doc(uid).update({
        'inventory_level_$item': level,
      });
      print('Inventory level updated successfully for $item');
    } catch (e) {
      print('Error updating inventory level: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Shubhash Stationary'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Particulars",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Inventory',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pen",
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _selectedPen,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPen = newValue!;
                          // Call function to update inventory level
                          updateInventoryLevel('pen', _selectedPen);
                        });
                      },
                      items: <String>[
                        'High',
                        'Medium',
                        'Low',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pencils",
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _selectedPencils,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPencils = newValue!;
                          // Call function to update inventory level
                          updateInventoryLevel('pencils', _selectedPencils);
                        });
                      },
                      items: <String>[
                        'High',
                        'Medium',
                        'Low',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Books",
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _selectedBooks,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBooks = newValue!;
                          // Call function to update inventory level
                          updateInventoryLevel('books', _selectedBooks);
                        });
                      },
                      items: <String>[
                        'High',
                        'Medium',
                        'Low',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 300,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.red,
                        maximumSize:
                            Size(MediaQuery.of(context).size.width, 40),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 40)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginPage()));
                    },
                    child: const Text("Log Out")),
                const SizedBox(height: 20),
                Text(_notificationStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
