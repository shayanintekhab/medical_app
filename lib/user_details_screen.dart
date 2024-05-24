import 'global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailsScreen extends StatefulWidget {
  String? userID;
  UserDetailsScreen({
    super.key,
    this.userID,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String name = '';
  String email = '';
  String password = '';
  String city = "";
  String country = "";
  String phoneNo = "";
  String address = "";

  retrieveUserInfo() async {
    print("current" + currentUserID);
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(currentUserID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
       
        setState(() {
          // print("User ID: ${FirebaseAuth.instance.currentUser!.uid}");
          name = snapshot.data()!["name"] ?? "";

          email = snapshot.data()!["email"] ?? "";
          city = snapshot.data()!["city"] ?? "";

          country = snapshot.data()!["country"] ?? "";
          address = snapshot.data()!["address"] ?? "";

          phoneNo = snapshot.data()!["phoneNumber"] ?? "";
        });
      } 
    });
  }

  @override
  void initState() {
    super.initState();

    retrieveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Profile",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      "images/samaritan_logo.jpg",
                      width: 250,
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Personal Info",
                          style: TextStyle(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),

                    // personal info table

                    Container(
                      color: Color.fromARGB(255, 160, 213, 244),
                      padding: const EdgeInsets.all(20),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text(
                              "Name: ",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 16, 16, 16),
                                fontSize: 18,fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                          const TableRow(
                            children: [
                              Text(""),
                              Text(""),
                            ],
                          ),
                          TableRow(children: [
                            const Text(
                              "Email: ",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 5, 5, 5), fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              email,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 6, 6, 6),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                          const TableRow(
                            children: [
                              Text(""),
                              Text(""),
                            ],
                          ),
                          TableRow(children: [
                            const Text(
                              "Address: ",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 5, 5, 5), fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              address,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                          const TableRow(
                            children: [
                              Text(""),
                              Text(""),
                            ],
                          ),
                          TableRow(children: [
                            const Text(
                              "City: ",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 12, 12, 12), fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              city,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 9, 9, 9),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                          const TableRow(
                            children: [
                              Text(""),
                              Text(""),
                            ],
                          ),
                          TableRow(children: [
                            const Text(
                              "Country: ",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 12, 12, 12), fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              country,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 15, 15, 15),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                          const TableRow(
                            children: [
                              Text(""),
                              Text(""),
                            ],
                          ),
                          TableRow(children: [
                            const Text(
                              "Phone no: ",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 11, 11, 11), fontSize: 18,fontWeight: FontWeight.w500),
                            ),
                            Text(
                              phoneNo,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 3, 3, 3),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
