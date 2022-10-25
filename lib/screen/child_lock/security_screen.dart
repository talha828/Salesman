
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  TextEditingController txt1,txt2,txt3,txt4;
  DateFormat format = DateFormat("ddMM");
  var date = DateTime.now();
  String code;
  String dateCheck;
  // void getAllCustomerData(bool data) async {
  //   if(true){
  //     try {
  //       String actualAddress;
  //       Coordinates userLatLng;
  //       List<CustomerModel>customer;
  //       Provider.of<CustomerList>(context,listen: false).setLoading(true);
  //       var data =await loc.Location().getLocation();
  //       List<AddressModel>addressList=[];
  //       userLatLng=Coordinates(data.latitude,data.longitude);
  //       String mapApiKey="AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
  //       String _host = 'https://maps.google.com/maps/api/geocode/json';
  //       final url = '$_host?key=$mapApiKey&language=en&latlng=${userLatLng.latitude},${userLatLng.longitude}';
  //       print(url);
  //       if(userLatLng.latitude != null && userLatLng.longitude != null){
  //         var response1 = await http.get(Uri.parse(url));
  //         if(response1.statusCode == 200) {
  //           Map data = jsonDecode(response1.body);
  //           String _formattedAddress = data["results"][0]["formatted_address"];
  //           var address = data["results"][0]["address_components"];
  //           for(var i in address){
  //             addressList.add(AddressModel.fromJson(i));
  //           }
  //           actualAddress=addressList[3].shortName;
  //           Provider.of<CustomerList>(context,listen: false).updateAddress(actualAddress);
  //           print("response ==== $_formattedAddress");
  //           _formattedAddress;
  //         }
  //         var response = await OnlineDatabase.getAllCustomer();
  //         print("Response code is " + response.statusCode.toString());
  //         if (response.statusCode == 200) {
  //           var data = jsonDecode(utf8.decode(response.bodyBytes));
  //           //print("Response is" + data.toString());
  //
  //           for (var item in data["results"]) {
  //             double dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="null"?1.toString():item["LONGITUDE"].toString()),userLatLng.latitude,userLatLng.longitude);
  //             customer.add(CustomerModel.fromModel(item,distance: dist));
  //           }
  //
  //           for(int i=0; i < customer.length-1; i++){
  //             for(int j=0; j < customer.length-i-1; j++){
  //               if(customer[j].distance > customer[j+1].distance){
  //                 CustomerModel temp = customer[j];
  //                 customer[j] = customer[j+1];
  //                 customer[j+1] = temp;
  //               }
  //             }
  //           }
  //           Provider.of<CustomerList>(context,listen: false).clearList();
  //           Provider.of<CustomerList>(context,listen: false).storeResponse(data);
  //           Provider.of<CustomerList>(context,listen: false).getAllCustomer(customer);
  //           Provider.of<CustomerList>(context,listen: false).getDues(customer);
  //           Provider.of<CustomerList>(context,listen: false).getAssignShop(customer);
  //           print("done");
  //           setState(() {
  //
  //           });
  //           //print("length is"+limitedcustomer.length.toString());
  //           Provider.of<CustomerList>(context,listen: false).setLoading(false);
  //
  //         } else if (response.statusCode == 400) {
  //           var data = jsonDecode(utf8.decode(response.bodyBytes));
  //           Fluttertoast.showToast(
  //               msg: "${data['results'].toString()}",
  //               toastLength: Toast.LENGTH_SHORT,
  //               backgroundColor: Colors.black87,
  //               textColor: Colors.white,
  //               fontSize: 16.0);
  //           Provider.of<CustomerList>(context,listen: false).setLoading(false);
  //         }}
  //     } catch (e, stack) {
  //       print('exception is' + e.toString());
  //       Fluttertoast.showToast(
  //           msg: "Error: " + e.toString(),
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.black87,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       Provider.of<CustomerList>(context,listen: false).setLoading(false);
  //     }
  //   }
  // }
  // calculateDistance(double lat1,double long1,double lat2,double long2) {
  //   var distance = geo.Geolocator.distanceBetween(lat2,
  //       long2, lat1, long1);
  //   return distance / 1000;
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAllCustomerData(true);
    txt1=TextEditingController();
    txt2=TextEditingController();
    txt3=TextEditingController();
    txt4=TextEditingController();
    code = format.format(date);
    print(code);
  }

  getDate(){
    var date = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    var width=media.width;
    return WillPopScope(
      onWillPop: () =>  Future.value(false),
      child: SafeArea(child: Scaffold(body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          VariableText(text: "Enter the 4-digit code",
            fontsize: 16,
            textAlign: TextAlign.start,
            line_spacing: 1,
            fontcolor: textcolorblack,
            fontFamily: fontRegular,),
            SizedBox(height: height*0.005),
            VariableText(text: "DD-MM",
              fontsize: 16,
              textAlign: TextAlign.start,
              line_spacing: 1,
              fontcolor: textcolorblack,
              fontFamily: fontBold),
          SizedBox(height: height*0.01,),
          Row(
            children: [
              createCodeField(txt1,txt2),SizedBox(width: 15),
              createCodeField(txt2,txt3),SizedBox(width: 15),
              createCodeField(txt3,txt4),SizedBox(width: 15),
              createCodeField(txt4,null),
            ],
          ),
          /*OTPTextField(
            length: 4,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            style: TextStyle(
                fontSize: 16,
                fontFamily: fontRegular,
                fontWeight: FontWeight.w500
            ),
            keyboardType:TextInputType.number ,
            textFieldAlignment: MainAxisAlignment.start,
            otpFieldStyle: OtpFieldStyle(
              enabledBorderColor: Color(0xff7A7A7A),
              focusBorderColor: Color(0xff7A7A7A),
            ),
            fieldStyle: FieldStyle.underline,
            onCompleted: (pin) {
              dateCheck = pin;
              print("Completed: " + pin);
            },
          ),*/
            SizedBox(height: height*0.05),
            LoginButton(text: "Done",onTap: (){
              if(dateCheck == code){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
              }else{
                Fluttertoast.showToast(msg: "Incorrect password",toastLength: Toast.LENGTH_SHORT);
              }
            },),
        ],),
      ),)),
    );
  }

  Widget createCodeField(TextEditingController cont,TextEditingController next_cont){
    return Expanded(
        child:CodeField(
            cont: cont,
            next_cont: next_cont,
          onComplete: (value){
              setState(() {
                dateCheck = txt1.text+txt2.text+txt3.text+txt4.text;
              });
              print(dateCheck);
          },
        ));
  }
}
