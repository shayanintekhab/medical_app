

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/bluetoothscanner.dart';
import 'package:patient_app/chat_Screen.dart';
import 'package:patient_app/physical_check.dart';
import 'package:patient_app/scan_device.dart';
import 'package:patient_app/user_details_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List tabscreensList = [
    
    PhysicalCheck(),
    ChatScreen1(),
    BluetoothExample(),
   
    

    UserDetailsScreen(
      userID: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (indexNumber) {
          setState(() {
            screenIndex = indexNumber;
            
          });
        },
        
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.work_history,
                size: 30,
              ),
              label: ""),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble,
                size: 30,
              ),
              label: ""),

              BottomNavigationBarItem(
              icon: Icon(
                Icons.bluetooth,
                size: 30,
              ),
              label: ""),
           

             

          

              

              
          
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: ""),
        ],
      ),
      
      body: tabscreensList[screenIndex],
      
    );
  }
}
