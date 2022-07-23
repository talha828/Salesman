import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/globalvariable.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';


class AgingScreen extends StatefulWidget {
  @override
  State<AgingScreen> createState() => _AgingScreenState();
}

class _AgingScreenState extends State<AgingScreen> {
 List model =[];
 List name=[];
 List id=[];
 List today= [];
 List tomorrow=[];
 Future get_data() async {
    var url = Uri.parse(directory +
        'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_datatype=AGING');
    // var url  = await http.get(Uri.parse(url));
    // print(url.toString());
    await http.get(url).then((response) {
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        //print("data is: "+data.toString());
        var datalist = data['results'];
        if (datalist != null) {
          for (var item in data['results']) {
            // print(item['DATA']);
            for (var i in item['DATA']) {
              name.add(i['CUSTOMER']);
              id.add(i['CUST_CODE']);
              today.add(i['TODAYS']);
              tomorrow.add(i['TOMORROWS']);
            }
          }
        }
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }

  var f = NumberFormat("###,###.0#", "en_US");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(
        title: 'Aging Details',
        ontap: () {
          Navigator.pop(context);
        },
      ),
      body: FutureBuilder<void>(
        future: get_data(),
        builder: (context, data) {
          if(name.length==0){
            return Center(child: Text("No record found"));
          }
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.builder(
                  itemCount: name.length,
                  itemBuilder: (context, index) {
                    return AgingCard(
                        id: id[index],
                        name: name[index],
                        today: f.format(double.parse(today[index].toString())),
                        tomorrow:
                            f.format(double.parse(tomorrow[index].toString())));
                  }));
        },
      ),
    ));
  }
}

class AgingCard extends StatelessWidget {
  const AgingCard({
    Key key,
    @required this.id,
    @required this.name,
    @required this.today,
    @required this.tomorrow,
  }) : super(key: key);

  final String id;
  final String name;
  final String today;
  final String tomorrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
          border: Border.all(color: Colors.white)),
      child: Column(
        children: [
          AgingCardText(
            firstText: '',
            secondText: id,
            thridText: '',
            fourText: name,
            color: themeColor1,
          ),
          AgingCardText(
            firstText: "Today: ",
            secondText: today,
            thridText: "Tomorrow: ",
            fourText: tomorrow,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class AgingCardText extends StatelessWidget {
  AgingCardText(
      {this.firstText,
      this.secondText,
      this.thridText,
      this.fourText,
      this.color});
  final String firstText;
  final String secondText;
  final String thridText;
  final String fourText;
  final color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    firstText,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontFamily: fontMedium),
                  ),
                  Container(
                      child: Text(
                    secondText,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontFamily: fontRegular),
                  )),
                ],
              ),
            )),
        Container(child: Text('|')),
        Flexible(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Text(
                    thridText,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontFamily: fontMedium),
                  ),
                  Flexible(
                      child: Container(
                          child: Text(
                    fourText,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: fontRegular,
                        color: color),
                  ))),
                ],
              )),
        ),
      ],
    );
  }
}
