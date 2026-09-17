import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:maney_management_new/Home.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  @override
  void initState() {
    startNavigator();
    super.initState();
  }

  void startNavigator() async {
    await Future.delayed(Duration(seconds: 2));
    Get.offAll(()=> Home());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/icon.png",
              width: 180,
              height: 180,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 10),
            Text(
              "إدارة الأموال",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 50,),
            CircularProgressIndicator(color: Color(0xFF2C3E50),),
          ],
        ),
      ),
    );
  }
}
