import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/bank_account_model.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';

class BankAccountScreen extends StatefulWidget {
  List<CustomerModel> shopDetails;
  BankAccountScreen({this.shopDetails});


  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  TextEditingController amount = new TextEditingController();
  Map<String,dynamic> Bank={
    'bank':[
      {'name':'Allied Bank Limited',
      'image':'assets/icons/allied.png',
      'location':'Branch : Askari Branch'
      },
      {'name':'Dubai Islamic Bank',
        'image':'assets/icons/dubaiislamicbank.png',
        'location':'Branch : Gulshan-e-Iqbal Block 4 Branch'
      },
      {'name':'Muslim Commercial Bank (MCB)  ',
        'image':'assets/icons/mcb.png',
        'location':'Branch : Gulshan-e-Jamal Branch'
      },
      {'name':'Allied Bank (MCB)  ',
        'image':'assets/icons/alliedmcb.png',
        'location':'Branch : Rashid Minas Road Branch'
      },
      {'name':'Mezzan Bank Limited',
        'image':'assets/icons/meezan.png',
        'location':'Branch : Gulistan-e-Johor Branch'
      },
    ]
  };
  BankAccountModel selectedBankData;
  int bankSelect=-1;
  File image;
  bool showImage=false;

  bool selectBank=false;
bool showSelectedBank=false;
  double sizedBoxValue=0.03;
  bool isLoading=false;
  bool isLoading2=false;
  List<BankAccountModel> bankaccounts=[];
  BankAccountModel sel_account;

  Future<List<BankAccountModel>> getAllBankAccount() async{
  setState(() {
    isLoading2=true;
  });
    List<BankAccountModel> tempbank = await OnlineDatabase.getbankAccount();
   // isLoading=false;
    setState(() {
      bankaccounts = tempbank;
    });
  setState(() {
    isLoading2=false;
  });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBankAccount();
  }

  _onSelected(int i){
    setState(() {
      bankSelect=i;
    });
  }

  _uploadImg(bool fromCamera) async {
    if(fromCamera){
      XFile image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 50
      );
      if(image !=null){
        print(image.path);
        setState(() {
          this.image = File(image.path);
          showImage = true;
        });
      }
    }else{
      XFile image = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      if(image !=null){
        print(image.path);
        setState(() {
          this.image = File(image.path);
          showImage = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width =media.width;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: MyAppBar(title: showSelectedBank==true && selectBank==false?"Bank Account Details": 'Bank Deposit Details', ontap: (){
            Navigator.pop(context);},
            color: themeColor1,color2: themeColor2,) ,
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height*sizedBoxValue,),
                  Container(
                    height: height*0.07,
                    decoration: BoxDecoration(
                      //color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xffEEEEEE))
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                      child: InkWell(
                        onTap: (){
                          if(selectBank==false){
                            setState(() {
                              selectBank=true;
                            });
                          }
                          else{
                            setState(() {
                              selectBank=false;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/icons/bankaccount.png',scale: 3,color: Colors.black,),
                            SizedBox(width: height*0.015,),
                            VariableText(
                              text: 'Select Your Nearest Bank Details',
                              fontsize:15,fontcolor: Color(0xffC5C5C5),
                              weight: FontWeight.w500,
                              fontFamily: fontRegular,
                            ),
                            Spacer(),
                            Image.asset(selectBank==true?'assets/icons/arrowup.png':'assets/icons/arrowdown.png',scale: 3,color: Colors.black,),
                          ],
                        ),
                      ),


                    ),
                  ),
                  SizedBox(height: height*0.03,),
                  selectBank?Container(
                   height: height*0.40,

                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                          border: Border.all(color: Color(0xffEEEEEE)),
                        borderRadius: BorderRadius.circular(5),

                        //color: Colors.red
                      ),
                      child:
                      isLoading2?ProcessLoadingWhite():
                      ListView.separated(

                          separatorBuilder: (context, index) => Padding(
                            padding: EdgeInsets.zero,
                            child: Divider(
                              color:Color(0xffEEEEEE),
                            ),
                          ),
                          //itemCount:Bank['bank'].length,
                          itemCount:bankaccounts.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context,int index){
                            return     Padding(
                              padding:  EdgeInsets.only(left: height*0.01,right: height*0.01),
                              child: InkWell(
                                onTap: (){
                                  _onSelected(index);
                                  setState(() {
                                    selectBank=false;
                                    showSelectedBank=true;
                                  selectedBankData=bankaccounts[index];
                                  print("data"+selectedBankData.toString());
                                  });

                                },
                                child: Container(
                                  height: height*0.06,
                                  color:     bankSelect==index?Color(0x40FFCB9F):Colors.transparent,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Container(
                                          height: height*0.06,

                                          child:
                                          Image.asset('assets/icons/bankaccount.png',scale: 3,color: Colors.black,),

                                          //Image.asset(Bank['bank'][index]['image'],scale: 3.5,),
                                        ),
                                      ),
                                      SizedBox(width: height*0.0085,),
                                      Expanded(
                                        flex:7,
                                        child: Container(
                                          //height: height*0.06,
                                          decoration: BoxDecoration(

                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Padding(
                                            padding:  EdgeInsets.symmetric(horizontal: height*0.01),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                VariableText(text:bankaccounts[index].bankName,fontsize: 14,weight: FontWeight.w400,fontcolor: Color(0xff333333),),
                                                VariableText(text:bankaccounts[index].accountTitle,fontsize: 11,weight: FontWeight.w400,fontcolor: textcolorgrey,),



                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })

                  ):
                  Container(),
                  showSelectedBank==true && selectBank==false?
                      Column(children: [  Container(
                          height: height*0.09,
                          decoration: BoxDecoration(
                              color:     Color(0x40FFCB9F),
                              borderRadius: BorderRadius.circular(6)
                          ),

                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenpadding),
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex:1,
                                  child: Container(
                                    height: height*0.09,
                                    child:
                                    Image.asset('assets/icons/bankaccount.png',scale: 3,color: Colors.black,),

                                    //Image.asset(selectedBankData['image'],scale: 3.5,),
                                  ),
                                ),
                                SizedBox(width: height*0.0085,),
                                Expanded(
                                  flex:7,
                                  child: Container(
                                    //height: height*0.06,
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: height*0.01),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          VariableText(text:selectedBankData.bankName,fontsize: 14,weight: FontWeight.w400,fontcolor: Color(0xff333333),),
                                          SizedBox(height: height*0.0035,),
                                          VariableText(text:selectedBankData.accountTitle,fontsize: 11,weight: FontWeight.w400,fontcolor: textcolorgrey,),



                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                        SizedBox(height: height*0.02,),
                        RectangluartextFeild(
                          hinttext:selectedBankData.bankName,
                          enable: false,
                          enableborder: true,
                          bordercolor: Color(0xffEEEEEE),
                          //: name,
                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.text,
                          hintTextColor: textcolorblack,
                          textlength: 25,
                          containerColor: Colors.transparent,
                        ),
                        /*Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xE5E5E5),
                          ),
                          height: height * 0.065,
                          child: InputDecorator(

                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color:Color(0xffEEEEEE),)
                              ),
                              focusedBorder: OutlineInputBorder(


                                  borderSide: BorderSide(color: Colors.red)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                            ),

                            child:
                            DropdownButtonHideUnderline(
                                child: DropdownButton<BankAccountModel>(
                                    icon:Icon(Icons.arrow_drop_down),

                                    hint: Padding(

                                      padding: const EdgeInsets.only(left:8.0,),
                                      child:
                                      Text("Account Title", style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,

                                          fontFamily: fontRegular,
                                          color: Color(0xffB2B2B2,))),
                                    ),
                                    value: sel_account,
                                    isExpanded: true,
                                    onTap: (){
                                    },
                                    onChanged: (title){
                                      setState(() {
                                        sel_account=title;
                                        selected_bank_title=true;
                                       // print("selectedAccountTitle is: "+selectedAccountTitle.id.toString()+" "+selectedAccountTitle.name);
                                      });
                                    },
                                    style: TextStyle( fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: fontRegular,
                                        color: textcolorblack),
                                    items:
                                    bankaccounts.map<DropdownMenuItem<BankAccountModel>>((BankAccountModel item) {
                                      return DropdownMenuItem<BankAccountModel>(
                                        value: item,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: VariableText(
                                              text: item.accountTitle.toString(),
                                              fontsize: 13,
                                              weight: FontWeight.w400,
                                              fontFamily: fontRegular,
                                              fontcolor: textcolorblack
                                          ),
                                        ),
                                      );
                                    }).toList()
                                )),
                          ),
                        ),*/
                       SizedBox(height: height*0.01,),
                        RectangluartextFeild(
                          hinttext:selectedBankData.accountNumber,
                          enable: false,
                          enableborder: true,
                          bordercolor: Color(0xffEEEEEE),
                          //: name,
                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.text,
                          hintTextColor: textcolorblack,
                          textlength: 25,
                          containerColor: Colors.transparent,
                        ),
                        SizedBox(height: height*0.01,),
                        RectangluartextFeild(
                          hinttext: "Enter the amount for deposit",
                          enableborder: true,
                          bordercolor: Color(0xffEEEEEE),
                          cont:amount ,
                          keytype: TextInputType.number,
                          textlength: 25,
                          containerColor: Colors.transparent,
                        ),
                        SizedBox(height: height*0.02,),
                        showImage!=true ?Row(
                          children: [
                            DottedBorder(
                                color: Color(0xffE5E5E5),//color of dotted/dash line
                                strokeWidth: 1.5, //thickness of dash/dots
                                dashPattern: [8,4],
                                child:
                                Container(
                                  height: height*0.20,
                                  width: width*0.42,
                                  color: Color(0xffE5E5E5),
                                  child: GestureDetector(
                                      onTap: (){
                                        _uploadImg(true);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/icons/camera.png",scale: 3.5,),
                                          SizedBox(height: height*0.02,),
                                          VariableText(text: "Camera",
                                            fontsize: 13,
                                            weight: FontWeight.w400,
                                            fontcolor: textcolorblack,
                                            fontFamily: fontRegular,),
                                        ],
                                      )),
                                )
                            ),
                            Spacer(),
                            //dash patterns, 10 is dash width, 6 is space width
                            DottedBorder(
                                color: Color(0xffE5E5E5),//color of dotted/dash line
                                strokeWidth: 1.5, //thickness of dash/dots
                                dashPattern: [8,4],
                                child:
                                Container(
                                  height: height*0.20,
                                  width: width*0.42,
                                  color: Color(0xffE5E5E5),
                                  child: GestureDetector(
                                      onTap: (){
                                        _uploadImg(false);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Image.asset("assets/icons/gallery.png",scale: 3.5,),
                                          SizedBox(height: height*0.02,),
                                          VariableText(text: "Gallery",
                                            fontsize: 13,
                                            weight: FontWeight.w400,
                                            fontcolor: textcolorblack,
                                            fontFamily: fontRegular,),
                                        ],
                                      )),
                                )
                            ),
                          ],
                        ) :
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: height*0.20,
                                width: width,
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showImage=false;
                                      image = null;
                                    });

                                  },
                                  child:
                                  Stack(
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: <Color>[Colors.grey, Colors.grey],

                                          ).createShader(bounds);
                                        },
                                        child: Image.file(
                                          image,
                                          height: height*0.20,
                                          width: width,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),

                                      Align(
                                        child: Container(
                                          height:30,
                                          width:30,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Icon(Icons.remove,color: Colors.white,),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height*0.02,),
                        InkWell(
                          onTap: (){
                            if(validateFeilds()){
                              postCashDeposit();
                            }
                         },
                          child: Center(
                            child: Container(
                              height: height*0.05,
                              width: width*0.30,
                              decoration: BoxDecoration(
                                color: themeColor1,
                                borderRadius: BorderRadius.circular(4),

                              ),

                              child:   Padding(
                                padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                                child: Center(
                                  child: VariableText(
                                    text: 'Submit',
                                    weight: FontWeight.w500,
                                    fontsize: 14,
                                    fontFamily: fontRegular,
                                    fontcolor: themeColor2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.01),

                       ],):
                  Container(),



                ],
              ),
            ),
          ),

        ),
        isLoading?Positioned.fill(child: ProcessLoading()):Container(),
      ],
    );
  }

  bool validateFeilds(){
    bool ok=false;
    if(amount.text.isNotEmpty){
      ok=true;
    }
    else{
      Fluttertoast.showToast(msg: "Please Enter Amount",toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }

  setLoading(bool loading){
    setState(() {
      isLoading=loading;
    });
  }

  postCashDeposit() async {
    FocusScope.of(context).unfocus();
    setLoading(true);
    if(image != null){
      var tempImage = await MultipartFile.fromFile(image.path,
          filename: "${DateTime.now().millisecondsSinceEpoch.toString()}.${image.path.split('.').last}",
          contentType: new MediaType('image', 'jpg'));
      print(tempImage.filename);
      postImage(tempImage);
    }else{
      postData('');
    }
  }

  postData(String imageUrl) async {
    var location=await Location().getLocation();
    var response=await OnlineDatabase.postCashDeposite(imageUrl: imageUrl, long: location.longitude.toString(),lat: location.latitude.toString(),accountNumber: selectedBankData.accountNumber,amount: amount.text);
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode==200){
      setLoading(false);
      Fluttertoast.showToast(msg: "Cash deposit successfully",toastLength: Toast.LENGTH_SHORT);
      setState(() {
        amount.clear();
        showSelectedBank = false;
        bankSelect=-1;
      });
      //Navigator.push(context, MaterialPageRoute(builder: (_)=>MainMenuScreen()));
    }
    else{
      setLoading(false);
      Fluttertoast.showToast(msg: "Something went wrong",toastLength: Toast.LENGTH_SHORT);
    }
  }

  void postImage(var image) async {
    try {
      var response = await OnlineDatabase.uploadImage(
          type: 'bankdeposit',
          image: image
      );
      if(response){
        setLoading(false);
        print("Success");
        String imageUrl = 'https://suqexpress.com/assets/images/customer/${image.filename}';
        postData(imageUrl);
      }else{
        setLoading(false);
        print("failed");
        Fluttertoast.showToast(msg: 'Image upload failed', toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e, stack) {
      setLoading(false);
      print('exception is: ' + e.toString());
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }
}
