import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';

class OtherScreen extends StatefulWidget {
  // CustomerModel shopData;
  // var lat,long;
  // OtherScreen({this.shopData,this.lat,this.long});

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {

  bool checkOrderSummary=false;
  double sizedboxvalue=0.03;
  bool hassubissue=false;
  bool isLoading=false;
  bool isLoading2=false;

  // List<MainIssue> mainissues;
  // MainIssue sel_mainissues;
  // List<SubIssue> subissues;
  // SubIssue sel_subissues;
  // int count=0;
  // initState()  {
  //   // TODO: implement initState
  //   super.initState();
  //   getMainIssue();
  //
  // }
  // Future<List<MainIssue>> getMainIssue() async{
  //   setState(() {
  //     isLoading=true;
  //   });
  //   List<MainIssue> tempissue = await OnlineDataBase.getMainIssue();
  //
  //   setState(() {
  //     mainissues = tempissue;
  //     isLoading=false;
  //   });
  //
  // }
  TextEditingController complainDescription=new TextEditingController();
  // Future<List<SubIssue>> getSubIssueByMainIssue(mainissueId) async{
  //   List<SubIssue> tempsubissue = await OnlineDataBase.getSubIssueByMainIssue(mainissueId);
  //   setState(() {
  //     subissues = tempsubissue;
  //   });
  // }
  List<String>  temp=["a","b","c","b","f"];
  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text("Other"),
            ),
            body: Stack(
              children: [
                isLoading?LoadingIndicator(width: width, height: height):
                SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height*sizedboxvalue,),
                          Center(
                            child: Image.asset(
                              "assets/images/complaindetails.png",
                              scale: 3,
                            ),
                          ),
                          SizedBox(height: height*sizedboxvalue,),
                          Center(
                            child: VariableText(
                              text: 'Complaints Details',
                              fontsize:22,fontcolor:textcolorblack,
                              weight: FontWeight.w700,
                              fontFamily: fontRegular,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          VariableText(
                            text: 'Select Reasons',
                            fontsize:12,
                            fontFamily: fontMedium,
                            weight: FontWeight.w500,
                            fontcolor: textcolorblack,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xE5E5E5),
                            ),
                            height: height * 0.065,
                            child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:Color(0xff7A7A7A),)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                  contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                                ),

                                child:
                                DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        icon:Icon(Icons.arrow_drop_down),
                                        hint: Padding(

                                          padding: const EdgeInsets.only(left:8.0),
                                          child:
                                          Text("Technical", style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontLight,
                                              color: textcolorblack)),
                                        ),
                                        value: temp[0],
                                        isExpanded: true,
                                        onTap: (){

                                        },
                                        onChanged: (mainissue) async {
                                          // setState(() {
                                          //   temp[0]=mainissue;
                                          //
                                          //   // print("Selected area is: "+sel_reason.id.toString()+" "+sel_reason.name);
                                          // });
                                          // if(temp!=null){
                                          //   hassubissue = true;  temp.clear();
                                          //   temp=null;  }
                                          //
                                          // List<temp> a = await getSubIssueByMainIssue(sel_mainissues.code.toString());
                                          // setState(() {
                                          //   //areas = a;
                                          //   print("area list is"+subissues.toString());
                                          //   if(subissues!=null){
                                          //     hassubissue = true;
                                          //   }
                                          //   else{
                                          //     hassubissue=false;
                                          //   }
                                          // });
                                        },
                                        style: TextStyle(fontSize: 14,
                                            color:textcolorblack),
                                        items:
                                        temp.map<DropdownMenuItem<String>>((item) {
                                          return DropdownMenuItem(
                                            value: item,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: VariableText(
                                                text: item.toString(),
                                                fontsize: 12,
                                                fontcolor: Color(0xFF333333),
                                                fontFamily: fontRegular,
                                              ),
                                            ),
                                          );
                                        }).toList()
                                    ))),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          VariableText(
                            text: 'Issue',
                            fontsize:12,
                            fontFamily: fontMedium,
                            weight: FontWeight.w500,
                            fontcolor: textcolorblack,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xE5E5E5),
//border: Border.all(color: Color(0xff7A7A7A))
                            ),
                            height: height * 0.065,
                            child: InputDecorator(

                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:Color(0xff7A7A7A),)
                                  ),
                                  focusedBorder: OutlineInputBorder(


                                      borderSide: BorderSide(color: Colors.red)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                  contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                                ),

                                child:
                                DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        icon:Icon(Icons.arrow_drop_down),
                                        hint: Padding(

                                          padding: const EdgeInsets.only(left:8.0),
                                          child:
                                          Text("Other", style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontLight,
                                              color: textcolorblack)),
                                        ),
                                        value: temp[0],
                                        isExpanded: true,
                                        onTap: (){

                                        },
                                        onChanged: (subissue){
                                          // setState(() {
                                          //   temp=subissue;
                                          //
                                          //   // print("Selected area is: "+sel_issue.id.toString()+" "+sel_issue.name);
                                          // });
                                        },
                                        style: TextStyle( fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: textcolorblack),
                                        items:hassubissue?
                                        temp.map<DropdownMenuItem<String>>(( item) {
                                          return DropdownMenuItem(
                                            value: item,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: VariableText(
                                                  text: item.toString(),
                                                  fontsize: 13,
                                                  weight: FontWeight.w400,
                                                  fontFamily: fontLight,
                                                  fontcolor: textcolorblack
                                              ),
                                            ),
                                          );
                                        }).toList():[]
                                    ))),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          VariableText(
                            text: 'Describe your issue',
                            fontsize:12,
                            fontFamily: fontMedium,
                            weight: FontWeight.w500,
                            fontcolor: textcolorblack,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.20,
                            width: width ,
                            child: TextFormField(
                              style:  TextStyle( fontSize: 13,
                                  fontWeight: FontWeight.w400,

                                  fontFamily: fontLight,
                                  color: textcolorblack
                              ),
                              maxLines: 5,
                              maxLength: 1000,
                              controller: complainDescription,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xff7A7A7A),)
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                contentPadding: EdgeInsets.all(8),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                hintText: "Kindly type your issue as a note regarding the app.",

                                hintStyle: TextStyle( fontSize: 13,
                                    fontWeight: FontWeight.w400,

                                    fontFamily: fontLight,
                                    color: textcolorblack
                                ),

                              ),
                            ),



                          ),
                          /*SizedBox(
                    height: height * 0.05,
                  ),*/

                          // Spacer(),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: screenpadding),
                            child:
                            InkWell(
                              // onTap: (){
                              //   if(validateFields()) {
                              //     postComplaint();
                              //   }},
                              child: Container(
                                height: height*0.06,
                                decoration: BoxDecoration(
                                  color: themeColor1,
                                  borderRadius: BorderRadius.circular(4),

                                ),

                                child:   Center(
                                  child: VariableText(
                                    text: 'Complaint Submit',
                                    weight: FontWeight.w700,
                                    fontsize: 15,
                                    fontFamily: fontMedium,
                                    fontcolor: themeColor2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]

                    ),
                  ),
                ),


              ],
            )

        ),
        isLoading2?Positioned.fill(child: LoadingIndicator(width: width,height:height,),):Container()
      ],
    );
  }
  setLoading(bool loading){
    setState(() {
      isLoading2=loading;

    });
  }
  // bool validateFields(){
  //   bool ok=false;
  //   if(sel_mainissues!=null){
  //     if(sel_subissues!=null){
  //       if(complainDescription.text.isNotEmpty){
  //         ok=true;
  //       }
  //       else{
  //         Fluttertoast.showToast(
  //             msg: "Please Enter Complain Description", toastLength: Toast.LENGTH_SHORT);
  //       }
  //     }
  //     else{
  //       Fluttertoast.showToast(
  //           msg: 'Please Select Issue', toastLength: Toast.LENGTH_SHORT);
  //
  //     }
  //   }
  //   else{
  //     Fluttertoast.showToast(
  //         msg: 'Please Select Reason', toastLength: Toast.LENGTH_SHORT);
  //
  //   }
  //   return ok;
  //
  // }
  // postComplaint() async {
  //   try {
  //     setLoading(true);
  //     var response = await OnlineDataBase.postComplaint(customercode: widget.shopData.customerCode,reasonID: sel_mainissues.code,issueID: sel_subissues.subissuecode,complainDetails: complainDescription.text);
  //     print("status code is" + response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       var respnseData=jsonDecode(utf8.decode(response.bodyBytes));
  //       print("responsde is"+respnseData['results'].toString());
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //           msg: "Complain Added Successfully",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       Navigator.push(context, MaterialPageRoute(builder: (_)=>SucessFullySubmitComplaintScreen(shopDetails: widget.shopData,lat: widget.lat,long: widget.long,)));
  //     } else {
  //       setLoading(false);
  //       Fluttertoast.showToast(
  //         msg: "Something went wrong try again letter",
  //         toastLength: Toast.LENGTH_SHORT,
  //         backgroundColor: Colors.black87,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     }
  //   } catch (e,stack) {
  //     setLoading(false);
  //     Fluttertoast.showToast(
  //       msg: "Something went wrong try again letter",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.black87,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     print("exception in post complaint method is" + e.toString()+stack.toString());
  //   }
  // }
}
