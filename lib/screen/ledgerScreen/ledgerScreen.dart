import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesmen_app_new/model/customer_model.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';

class LedgerScreen extends StatefulWidget {

  @override
  _LedgerScreenState createState() => _LedgerScreenState();
}
class _LedgerScreenState extends State<LedgerScreen> {
  double sizedboxvalue=0.03;
  bool selectedValue=false;
  // List<LedgerDuration> durationList=[];
  // LedgerDuration selectedDuration;
  bool isLoading=false;
   String startDate="12/05/2022";
   String endDate="14/058/2022";
  // List<LedgerModel> ledgerData=[];
  DateTime now=new DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        helpText: "Select From Date",
        builder: (context, child) {
          return  Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor1, // header background color
                //onPrimary: Colors.black, // header text color
                //onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeColor1, // button text color
                ),
              ),
            ),

            child: child,
          );}
    );
    if (picked != null)
      setState(() {
        startDate=picked.toString().split(" ")[0];
      });

  }
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        helpText: "Select To Date",
        builder: (context,child) {
          return  Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor1, // header background color
                //onPrimary: Colors.black, // header text color
                //onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeColor1, // button text color
                ),
              ),
            ),
            child: child,
          );}
    );
    if (picked != null)
      setState(() {
        endDate=picked.toString().split(" ")[0];

      });

  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   durationList.add(LedgerDuration(id:0,name:'Today',duration: 0));
  //   durationList.add(LedgerDuration(id:1,name:'Yesterday',duration: 1));
  //   durationList.add(LedgerDuration(id: 2,name: 'Last Week',duration: 7));
  //   durationList.add(LedgerDuration(id: 3,name: 'This Month',duration: 30));
  //   durationList.add(LedgerDuration(id: 4,name: 'Last 2 Month',duration: 60));
  //   durationList.add(LedgerDuration(id: 5,name: 'Last 3 Month',duration: 90));
  //   //DateTime now=DateTime.now();
  //   //startDate=now.toString().split(" ")[0];
  //
  // }
  setLoading(bool loading){
    setState(() {
      isLoading=loading;
    });
  }
  File file;

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return Stack(
      children: [
        Scaffold(
          appBar:AppBar(title: Text("Ledger Screen",style: TextStyle(color: Colors.white),),),
          body:Padding(
            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height*sizedboxvalue,),
                VariableText(
                  text: 'SHOW REPORT',
                  fontsize:12,fontcolor:Color(0xff4D4D4D),
                  weight: FontWeight.w500,
                  fontFamily: fontMedium,
                ),
                SizedBox(height: height*sizedboxvalue,),
                /* Container(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Image.asset('assets/icons/calender.png',scale: 3.4,),
                         ),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<LedgerDuration>(
                                    icon:Icon(Icons.arrow_drop_down),

                                    hint: Padding(

                                      padding: const EdgeInsets.only(left:4.0,),
                                      child:
                                      Text("Select Duration", style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,

                                          fontFamily: fontRegular,
                                          color: textcolorlightgrey)),
                                    ),
                                    value: selectedDuration,
                                    isExpanded: true,
                                    onTap: (){
                                      },
                                    onChanged: (duration){
                                      setState(() {
                                        selectedDuration=duration;
                                        selectedValue=true;
                                        endDate= DateTime.now().subtract(Duration(days: selectedDuration.duration)).toString().split(" ")[0];
                                      //  print("selectedDuration is: "+selectedDuration.id.toString()+" "+selectedDuration.name+' '+selectedDuration.duration.toString());
                                     // print("start date"+startDate);
                                     // print("end date"+endDate);
                                      });
                                    },
                                    style: TextStyle( fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: fontRegular,
                                        color: textcolorblack),
                                    items:
                                    durationList.map<DropdownMenuItem<LedgerDuration>>((LedgerDuration item) {
                                      return DropdownMenuItem<LedgerDuration>(
                                        value: item,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: VariableText(
                                              text: item.toString(),
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
                        ],
                      )),
                ),
                SizedBox(height: height*sizedboxvalue,),*/

                InkWell(
                  onTap: (){
                    _selectDate(context);
                  },
                  child: Container(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/icons/calender.png',scale: 3.4,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child:  VariableText(
                                text: startDate!=null?startDate:'Select From Date',
                                fontsize:13,fontcolor:Color(0xff4D4D4D),
                                weight: FontWeight.w500,
                              ),
                            )

                          ],
                        )),
                  ),
                ),
                SizedBox(height: height*sizedboxvalue,),

                InkWell(
                  onTap: (){
                    _selectDate2(context);
                  },
                  child: Container(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/icons/calender.png',scale: 3.4,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child:  VariableText(
                                text: endDate!=null?endDate:'Select To Date',
                                fontsize:13,fontcolor:Color(0xff4D4D4D),
                                weight: FontWeight.w500,
                              ),
                            )

                          ],
                        )),
                  ),
                ),
                SizedBox(height: height*sizedboxvalue,),
                Row(
                  children: [
                    //     Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Customer Ledger',imagePath:'assets/icons/CustomerLedger.png',selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                    //       getLedger(height: height,width: width,ledgerType: 'PLEDGER',onScreen: false);
                    //
                    //     },)),
                    //     SizedBox(width: width*0.04,),
                    Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'User Cash Ledger as pdf',imagePath:'assets/icons/UserCashLedger.png',selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                      // getLedger(height: height,width: width,ledgerType: 'PCLEDGER',onScreen: false);

                    },)),
                    SizedBox(width: width*0.04,),
                    Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'User Cash Ledger view',imagePath:'assets/icons/UserCashLedger.png',selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                      // getLedger(height: height,width: width,ledgerType: 'PCLEDGER',onScreen: true);

                    },)),
                    // SizedBox(width: width*0.04,),
                    //     Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'User Cheque Ledger',imagePath:'assets/icons/UserChequeLedger.png',selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                    //       getLedger(height: height,width: width,ledgerType: 'PQLEDGER',onScreen: false);
                    //
                    //     },)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    // Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Dues Ledger',imagePath:'assets/icons/CustomerLedger.png',selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                    //   getLedger(height: height,width: width,ledgerType: 'DUESLEDGER',onScreen: false);
                    //   },)),
                    // SizedBox(width: width*0.04,),
                    Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Show Customer Ledger',imagePath:'assets/icons/CustomerLedger.png', selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                      // getLedger(height: height,width: width,ledgerType: 'PLEDGER',onScreen: true);
                    },)),
                    SizedBox(width: width*0.04,),
                    Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Show Dues Ledger',imagePath:'assets/icons/CustomerLedger.png',selectedValue:  startDate!=null&&endDate!=null?true:false,onTap: (){
                      // getLedger(height: height,width: width,ledgerType: 'DUESLEDGER',onScreen: true);
                    },)),
                  ],
                )

              ],
            ),
          ) ,
        ),
        isLoading?Positioned.fill(child: LoadingIndicator(width: width,height: height,)):Container()
      ],
    );
  }
}
//   getLedger({String ledgerType,double height,double width,bool onScreen}) async {
//     setLoading(true);
//     var response=await OnlineDataBase.getLedger(customerCode:  widget.shopDetails.customerCode,ledgerType: ledgerType,fromDate: startDate,toDate: endDate);
//     if(response.statusCode==200){
//       var data=jsonDecode(utf8.decode(response.bodyBytes));
//       print(data.toString());
//       var dataList=data['results'];
//
//       if(ledgerType=='PLEDGER'){
//         if(dataList.isNotEmpty){
//           print("list is"+dataList.toString());
//
//           for(var item in dataList){
//             ledgerData.add(LedgerModel.customerLedgerDate(item));
//           }
//           if(onScreen){
//             setLoading(false);
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>LedgerOnScreen(ledgerData: ledgerData,)));
//           }
//           else{
//             final pdfFile = await CustomerPdf.generate(ledgerDataList:ledgerData,startdate: startDate,endate: endDate,shopName: widget.shopDetails.customerShopName);
//             setLoading(false);
//             PdfApi.openFile(pdfFile);
//             ledgerData.clear();
//           }
//         }
//         else{
//           setLoading(false);
//           Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_SHORT);
//
//         }
//         // showDialog(height,width,'Customer Ledger');
//       }
//       else if(ledgerType=='PCLEDGER'){
//         if(dataList.isNotEmpty){
//           for(var item in dataList){
//             ledgerData.add(LedgerModel.cashLedgerDate(item));
//           }
//           if(onScreen){
//             setLoading(false);
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowCustomerLedger(ledgerData: ledgerData,shopDetails: widget.shopDetails,)));
//           }
//           else{
//             final pdfFile = await CashPdf.generate(ledgerDataList:ledgerData,startdate: startDate,endate: endDate,shopDetals: widget.shopDetails,balance: widget.balance);
//             setLoading(false);
//             PdfApi.openFile(pdfFile);
//             ledgerData.clear();
//           }
//         }
//         else{
//           setLoading(false);
//           Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_SHORT);
//
//         }
//         // showDialog(height,width,'User Cash Ledger');
//       }
//       else if(ledgerType=='PQLEDGER'){
//         if(dataList!=null){
//           for(var item in dataList){
//             ledgerData.add(LedgerModel.chequeLedgerDate(item));
//           }
//           final pdfFile = await ChequePdf.generate(ledgerDataList:ledgerData,startdate: startDate,endate: endDate,shopDetals: widget.shopDetails,balance: widget.balance);
//           setLoading(false);
//           PdfApi.openFile(pdfFile);
//           ledgerData.clear();
//
//
//         }
//         //showDialog(height,width,'User Cheque Ledger');
//       }
//       else if(ledgerType=='DUESLEDGER'){
//         if(dataList.isNotEmpty){
//           print("list is: "+dataList.toString());
//
//           for(var item in dataList){
//             ledgerData.add(LedgerModel.duesLedgerDate(item));
//           }
//           if(onScreen){
//             setLoading(false);
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowDuesLedger(ledgerData: ledgerData,)));
//           }
//           else {
//             final pdfFile = await DuesPdf.generate(ledgerDataList: ledgerData,
//                 startdate: startDate,
//                 endate: endDate,
//                 shopName: widget.shopDetails.customerName);
//             setLoading(false);
//             PdfApi.openFile(pdfFile);
//             ledgerData.clear();
//           }
//         }
//         else{
//           setLoading(false);
//           Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_SHORT);
//
//         }
//       }
//     }
//     else{
//       setLoading(false);
//       Fluttertoast.showToast(msg: "Some thing went wrong",toastLength: Toast.LENGTH_SHORT);
//     }
//   }
//
//
//   void showDialog(double height,double width,String text ) {
//     showGeneralDialog(
//       barrierLabel: "Barrier",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: Duration(milliseconds: 500),
//       context: context,
//       pageBuilder: (_, __, ___) {
//         return ShowPdfDialouge(height: height,width: width,text:text);
//       },
//       transitionBuilder: (_, anim, __, child) {
//         return SlideTransition(
//           position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
//           child: child,
//         );
//       },
//     );
//   }
// }
// class ShowPdfDialouge extends StatefulWidget {
//   double height,width;
//   String text;
//   ShowPdfDialouge({this.height,this.width,this.text});
//
//   @override
//   _ShowPdfDialougeState createState() => _ShowPdfDialougeState();
// }
//
// class _ShowPdfDialougeState extends State<ShowPdfDialouge> {
//   @override
//   double sizedboxvalue=0.02;
//
//   TextEditingController amount=new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
//           contentPadding: EdgeInsets.only(left: 16,right: 16,top: 60),
//           content:  RichText(
//             text: new TextSpan(
//               style: new TextStyle(
//                 fontSize: 14.0,
//                 color: textcolorblack,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: fontRegular,
//               ),
//               children: <TextSpan>[
//                 new TextSpan(text: 'Do you want to download '),
//                 new TextSpan(text: widget.text, style: new TextStyle(       fontSize: 14.0,
//                     color: textcolorblack,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: fontBold)),
//                 new TextSpan(text: ' file on your device? '),
//
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             new FlatButton(
//               onPressed: () {
//                 Navigator.of(context, rootNavigator: true)
//                     .pop(false); // dismisses only the dialog and returns false
//               },
//               child:   VariableText(
//                 text: 'Cancel',
//                 fontsize:12,fontcolor:themeColor1,
//                 weight: FontWeight.w500,
//                 fontFamily: fontRegular,
//               ),
//             ),
//             FlatButton(
//               onPressed: () {
//                 Navigator.of(context, rootNavigator: true)
//                     .pop(true); // dismisses only the dialog and returns true
//               },
//               child:  VariableText(
//                 text: 'Download',
//                 fontsize:12,fontcolor:themeColor1,
//                 weight: FontWeight.w500,
//                 fontFamily: fontRegular,
//               ),
//             ),
//           ],
//         ),
//         Padding(
//           padding:  EdgeInsets.only(bottom: widget.height*0.20),
//           child: Align(
//             alignment: Alignment.center,
//
//             child:  FloatingActionButton(
//                 mini: false,
//                 shape: StadiumBorder(
//                     side: BorderSide(
//                         color: Colors.white, width: 1)),
//                 backgroundColor: Color(0xffF6821F),
//                 child: Image.asset('assets/icons/download.png',scale: 4,),
//                 onPressed: () {
//                 }),
//           ),
//         ),
//       ],
//     );
//
//   }
//
//
//
//
// }



