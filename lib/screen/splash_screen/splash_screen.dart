import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(child: Image.asset("assets/images/splashIcon.png", scale: 2)),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("SKR Service 2021. All Right Reserved.",style: TextStyle(color: Colors.red,fontSize: 14),)
              )
            ],
          ),
        ));
  }
}