import 'controllers/authentication_controller.dart';
import 'widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController =
      TextEditingController();
  bool showProgressBar = false;
  var controllerAuth = AuthenticationController.authController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          const SizedBox(height: 120),
          Image.asset(
            "images/samaritan_logo.jpg",
            width: 250,
          ),
          const SizedBox(height: 20),
          const Text("Welcome ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Login to your Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width - 36,
            height: 55,
            child: CustomTextFieldWidget(
              editingController: emailTextEdittingController,
              labelText: "Email",
              iconData: Icons.email_outlined,
              isObscure: false,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: MediaQuery.of(context).size.width - 36,
            height: 55,
            child: CustomTextFieldWidget(
              editingController: passwordTextEdittingController,
              labelText: "Password",
              iconData: Icons.lock_outlined,
              isObscure: true,
            ),
          ),
          const SizedBox(height: 20),

          //login button
          Container(
            width: MediaQuery.of(context).size.width - 36,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: InkWell(
              onTap: () async {
                if (emailTextEdittingController.text.trim().isNotEmpty &&
                    passwordTextEdittingController.text.trim().isNotEmpty) {
                  setState(() {
                    showProgressBar = true;
                  });
                  await controllerAuth.loginUser(
                      emailTextEdittingController.text.trim(),
                      passwordTextEdittingController.text.trim());
                  setState(() {
                    showProgressBar = false;
                  });
                } else {
                  Get.snackbar(
                      "Email/Password is Missing", "Please fill all fields.");
                }
              },
              child: const Center(
                child: Text("Login",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
          const SizedBox(height: 20),

          
          const SizedBox(height: 20),
          showProgressBar == true
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                )
              : Container(),
          const SizedBox(height: 20),
        ],
      )),
    ));
  }
}
