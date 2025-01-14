import 'package:chatapp_yt/pages/registrationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  bool _issignup = false;
  TextEditingController emailcont = TextEditingController();
  TextEditingController passcont = TextEditingController();
  final FirebaseAuth _user = FirebaseAuth.instance;
  void _toogle() {
    setState(() {
      _issignup = !_issignup;
    });
  }

  Future<void> signup() async {
    try {
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: Colors.blue,
        titleText: Text('Successfully Signup'),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      // Get.showSnackbar(GetSnackBar(
      // backgroundColor: Colors.red,
      // titleText: Text("Error ${e.toString()}"),
      // duration: const Duration(seconds: 3),
      //));
    }
  }

  Future<void> signin() async {
    try {
      // ignore: unused_local_variable
      UserCredential signin = await _user.signInWithEmailAndPassword(
          email: emailcont.text, password: passcont.text);
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: Colors.blue,
        titleText: Text('Successfully Signin'),
        duration: Duration(seconds: 3),
      ));

      Get.off(() => const Resgistrationform());
    } catch (e) {
      // Get.showSnackbar(GetSnackBar(
      //   backgroundColor: Colors.red,
      //   titleText: Text("Error ${e.toString()}"),
      //   duration: const Duration(seconds: 3),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.lightBlue,
      body: _buildUi(),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  controller: emailcont,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passcont,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: 200,
                    child: MaterialButton(
                      onPressed: () {
                        _issignup ? signup() : signin();
                      },
                      color: Colors.blue,
                      child: Text(_issignup ? 'Signup' : 'Signin'),
                    )),
                TextButton(
                  onPressed: _toogle,
                  child: Text(_issignup
                      ? 'Have and account? Signin'
                      : "Dont's have an account? Signup"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUi() {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Container(
        alignment: Alignment.topCenter,
        child: const Text(
          'Get Started!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ),
    );
  }
}
