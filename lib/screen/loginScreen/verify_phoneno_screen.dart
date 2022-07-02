import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';
import '../../others/style.dart';

class VerifyPhoneNoScreen extends StatefulWidget {

  @override
  _VerifyPhoneNoScreenState createState() => _VerifyPhoneNoScreenState();
}

class _VerifyPhoneNoScreenState extends State<VerifyPhoneNoScreen> {


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No',style: TextStyle(color: themeColor1),),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes',style: TextStyle(color: themeColor1),),
          ),
        ],
      ),
    )) ??
        false;
  }

  TextEditingController _numController=new TextEditingController();
  List<String> phoneCodes = ['+1', '+92'];
   String selectedCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCode = phoneCodes.first;
  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    var width=media.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body:   Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height*0.07,),
                Center(child: Image.asset("assets/images/splashlogo.png",scale: 3.5,)),
                SizedBox(height: height*0.05,),
                Text("What’s your number?",style: TextStyle(fontSize: 22,color:textcolorblack ,fontFamily: fontMedium),),
                SizedBox(height: height*0.01,),
                Text("We’ll text  a code to verify your phone.",style: TextStyle(fontSize: 13,color:textcolorgrey ,fontFamily: fontRegular),),
                SizedBox(height: height*0.03,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        // inputFormatters: [
                        //   LengthLimitingTextInputFormatter(11)],
                        style: TextStyle(
                            fontSize: 15,
                            color: textcolorblack
                        ),
                        //onChanged: enableBtn ,
                        controller: _numController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Number';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: feildunderlineColor),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 00,
                            horizontal: 5.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          hintText: '305 5520912',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: textcolorlightgrey,
                          ),
                          prefixIcon:
                          // Container(
                          //   child: DropdownButtonHideUnderline(
                          //       child: DropdownButton<String>(
                          //           isDense: true,
                          //           icon:Icon(Icons.arrow_drop_down),
                          //           value: selectedCode,
                          //           isExpanded: false,
                          //           onChanged: (value) {
                          //             setState(() {
                          //               selectedCode = value;
                          //             });
                          //           },
                          //           items: phoneCodes.map<DropdownMenuItem<String>>((String item) {
                          //             return DropdownMenuItem<String>(
                          //               value: item,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(left: 0.0),
                          //                 child: VariableText(
                          //                     text: item,
                          //                     fontsize: 15,
                          //                     weight: FontWeight.w600,
                          //                     fontFamily: fontLight,
                          //                     fontcolor: Colors.black
                          //                 ),
                          //               ),
                          //             );
                          //           }).toList()
                          //       )),
                          // ),
                          Padding(
                            padding:  EdgeInsets.only(right: 0,top: height*0.019),
                            child: Text(
                              '  +92',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ],

            ),
          ),
          floatingActionButton: new FloatingActionButton(
              elevation: 1.0,
              child:   Image.asset('assets/icons/arrow_forward.png',scale: 1.8,),
              backgroundColor: themeColor1,
              onPressed: (){
                nextScreen();
              }
          )
      ),
    );
  }
  void nextScreen() async{
    if(validateFields()) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen(phoneNumber: "+92"+_numController.text,)));
    }
  }
  bool validateFields(){
    bool ok=false;
    if(_numController.text.isNotEmpty && _numController.text.length >= 10){
      ok=true;
    }
    else{
      Fluttertoast.showToast(msg: "Please Enter Phone Number", toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }
}
