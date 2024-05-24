import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/chat_controller.dart';
import 'package:patient_app/push_notification.dart';
import 'package:patient_app/scan_device.dart';
import 'controllers/authentication_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCthRD3Ya7v5uJ_Vks7PpGb9mON_pGxDPs",
              appId: "1:912976744345:android:4c5cbd65054d9c91784d08",
              messagingSenderId: "912976744345",
              projectId: "air-visibility-app"))
      .then((value) {
    Get.put(AuthenticationController());
    Get.put(ScanController());
    Get.put(ChatController());
  });
  await Push_notification().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  return GetMaterialApp(
    title: 'Patients App',
    theme: ThemeData.dark().copyWith(
      primaryColor: Colors.blue, // Set primary color to blue
       // Set accent color to blue accent
      scaffoldBackgroundColor: Color.fromARGB(255, 131, 205, 243), // Set scaffold background color to white
      appBarTheme: AppBarTheme(
        color: Colors.blue, // Set app bar color to blue
        
        ),
         // Remove app bar elevation
      ),
      
    
       
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  );
}



}


