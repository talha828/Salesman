import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/model/ledger_duration.dart';
import 'package:salesmen_app_new/model/partyTrailLedgermodel.dart';
import 'package:salesmen_app_new/model/stockLedgerModel.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/model/walletledgermodel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/ReportsScreen/ShowWalletLedger.dart';
import 'package:salesmen_app_new/screen/ReportsScreen/partyTrailledger.dart';
import 'package:salesmen_app_new/screen/ReportsScreen/stockLedgerPdf.dart';
import 'package:salesmen_app_new/screen/ReportsScreen/walletLedger.dart';
import 'package:salesmen_app_new/screen/ledgerScreen/pdfapi.dart';





class ReportsScreen extends StatefulWidget {
 UserModel userdata;
  String balance;
  double lat,long;
  ReportsScreen({this.userdata,this.lat,this.long,this.balance});
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  double sizedboxvalue=0.03;
  bool selectedValue=false;
  List<LedgerDuration> durationList=[];
  LedgerDuration selectedDuration;
  bool isLoading=false;
  String startDate,endDate;
  DateTime now=DateTime.now();
  List<StockLedgerModel> stockledgerData=[];
  List<WalletLedgerModel> walletledgerData=[];
  List<PartyTrailLedgerModel> partyTrailData=[];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        helpText: "Select From Date",
        builder: (BuildContext context, Widget child) {
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
        builder: (BuildContext context, Widget child) {
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    durationList.add(LedgerDuration(id:0,name:'Today',duration: 0));
    durationList.add(LedgerDuration(id:1,name:'Yesterday',duration: 1));
    durationList.add(LedgerDuration(id: 2,name: 'Last Week',duration: 7));
    durationList.add(LedgerDuration(id: 3,name: 'This Month',duration: 30));
    durationList.add(LedgerDuration(id: 4,name: 'Last 2 Month',duration: 60));
    durationList.add(LedgerDuration(id: 5,name: 'Last 3 Month',duration: 90));
    //DateTime now=DateTime.now();
   // startDate=now.toString().split(" ")[0];
  }
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
          appBar: MyAppBar(title: 'Reports Details',ontap: (){
            Navigator.pop(context);
          },) ,
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
                /*Container(
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
                                        print(selectedDuration.duration);
                                        print(endDate);
                                        endDate= DateTime.now().subtract(Duration(days: selectedDuration.duration)).toString().split(" ")[0];
                                       //  print("selectedDuration is: "+selectedDuration.id.toString()+" "+selectedDuration.name+' '+selectedDuration.duration.toString());
                                       //  print("start date"+startDate);
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
                ),*/
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
                SizedBox(height: 15,),
                Expanded(
                  flex: 1,
                  child: CustomLegerContainer(height: height,width: width,title: 'Wallet Ledger View',imagePath:'assets/icons/CustomerLedger.png',selectedValue: startDate!=null&&endDate!=null?true:false,onTap: () async {
                    getWalletLedger(height: height,width: width,ledgerType: 'CASHLEDGER',onScreen: true);

                  },),
                ),
                    SizedBox(width: width*0.04,),
                     Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Wallet Ledger as PDF',imagePath:'assets/icons/CustomerLedger.png',selectedValue: startDate!=null&&endDate!=null?true:false,onTap: () async {
                      getWalletLedger(height: height,width: width,ledgerType: 'CASHLEDGER',onScreen: false);},)),
                     SizedBox(width: width*0.04,),
                    Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Party Trail Ledger',imagePath:'assets/icons/UserCashLedger.png',selectedValue: startDate!=null&&endDate!=null?true:false,onTap: (){
                      getpartytrialLedger(height: height,width: width,ledgerType: 'PARTYTRIAL');

                    },)),
                    // SizedBox(width: width*0.04,),
                    // Expanded( flex:1,child: CustomLegerContainer(height: height,width: width,title: 'Stock Ledger',imagePath:'assets/icons/UserChequeLedger.png',selectedValue: startDate!=null&&endDate!=null?true:false,onTap: (){
                    //   getstockLedger(height: height,width: width,ledgerType: 'STOCKLEDGER');
                    //
                    // },)),
                  ],
                ),

              ],
            ),
          ) ,
        ),
        isLoading?Positioned.fill(child: ProcessLoading()):Container()
      ],
    );
  }
  getstockLedger({String ledgerType,double height,double width}) async {
    setLoading(true);
    stockledgerData.clear();
    var response=await OnlineDatabase.getStockLedger(ledgerType: ledgerType,fromDate: startDate,toDate: endDate);
    if(response.statusCode==200){
      var data=jsonDecode(utf8.decode(response.bodyBytes));
      var dataList=data['results'];
      if(dataList.isNotEmpty){
          for(var item in dataList){
            stockledgerData.add(StockLedgerModel.fromJson(item));
          }
          final pdfFile = await StockLegerPdf.generate(ledgerdata:stockledgerData,userdata: widget.userdata);
          setLoading(false);
          PdfApi.openFile(pdfFile);
          stockledgerData.clear();
        }
      else{
        setLoading(false);
        Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_SHORT);

      }


    }
    else{
      setLoading(false);
      Fluttertoast.showToast(msg: "Some thing went wrong",toastLength: Toast.LENGTH_SHORT);
    }
  }


  getWalletLedger({String ledgerType,double height,double width,bool onScreen}) async {
    setLoading(true);
    var response=await OnlineDatabase.getWalletLedger(ledgerType: ledgerType,fromDate: startDate,toDate: endDate);
    if(response.statusCode==200){
      var data=jsonDecode(utf8.decode(response.bodyBytes));
      var dataList=data['results'];
      print("result is"+data['results'].toString());
      if(dataList.isNotEmpty){
          for(var item in dataList){
            walletledgerData.add(WalletLedgerModel.fromJson(item));
          }
            if(onScreen){
              setLoading(false);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowWalletLedger(walletledgerData:walletledgerData)));
            }
            else{
              final pdfFile = await WalletLedger.generate(ledgerdata:walletledgerData,);
              setLoading(false);
              PdfApi.openFile(pdfFile);
              walletledgerData.clear();
            }
        }
      else{
        setLoading(false);
        Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_SHORT);

      }


    }
    else{
      setLoading(false);
      Fluttertoast.showToast(msg: "Some thing went wrong",toastLength: Toast.LENGTH_SHORT);
    }
  }
  getpartytrialLedger({String ledgerType,double height,double width}) async {
    setLoading(true);
    var response=await OnlineDatabase.getPartyTrialLedger(ledgerType: ledgerType,fromDate: startDate,toDate: endDate);
    if(response.statusCode==200){
      var data=jsonDecode(utf8.decode(response.bodyBytes));
      var dataList=data['results'];
      if(dataList.isNotEmpty){
          for(var item in dataList){
            partyTrailData.add(PartyTrailLedgerModel.fronJson(item));
          }
          print("data is"+partyTrailData.length.toString());
          final pdfFile = await PartyTrailLedger.generate(ledgerdata:partyTrailData,startdate: startDate,);

          setLoading(false);
          PdfApi.openFile(pdfFile);
          partyTrailData.clear();
        }
      else{
        setLoading(false);
        Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_SHORT);

      }


    }
    else{
      setLoading(false);
      Fluttertoast.showToast(msg: "Some thing went wrong",toastLength: Toast.LENGTH_SHORT);
    }
  }


}



