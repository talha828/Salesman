import 'package:flutter/material.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/login_screen/verify_phoneno_screen.dart';

class GetStartedScreen extends StatefulWidget {

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/images/getstartedbottomimage.png",)),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(child: Image.asset("assets/images/splashlogo.png",scale: 3.5,)),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhoneNoScreen())),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: themeColor1,
                      ),
                      child: Text("Get Started!",style: TextStyle(color: Colors.white,fontSize: 15),),),
                  )

                )
              ],

            ),
          ),
        ],
      ),
    );
  }
}

