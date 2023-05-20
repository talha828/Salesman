import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/newModel/main_category_model.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';
import 'package:salesmen_app_new/widget/loding_indicator.dart';

class MainCategoryScreen extends StatefulWidget {
  const MainCategoryScreen({Key key}) : super(key: key);

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {

  bool error=false;
  Future<MainCategoryModel> getData() async {
    var response = await OnlineDatabase.getMainCategory();
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return MainCategoryModel.fromJson(data['results'][0]);
      // print("length:" + user.roles.length.toString());
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
      setState(() {
         error=true;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Select Category",style: TextStyle(color: themeColor1),),
        ),
        body: error?Center(child: Text("No category Found",style: TextStyle(color: Colors.grey),),):FutureBuilder<MainCategoryModel>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data.roles.toString());
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.04, horizontal: width * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(snapshot.data.roles.length > 1)
                       GridView.count(
                        mainAxisSpacing: width * 0.04,
                        crossAxisSpacing: width* 0.04,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: snapshot.data.roles.map((e) => InkWell(
                          onTap: (){
                            switch (e.roleId.toString()){
                              case "3":
                                Get.to(MainScreen());
                                break;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: width * 0.04, horizontal: width * 0.04),
                            decoration: BoxDecoration(
                                color: themeColor1.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            height: width * 0.4,

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(list[(e.roleId-1)].img,scale: 6,),
                                Text(list[(e.roleId-1)].title,style: TextStyle(fontWeight: FontWeight.w300,fontSize: width * 0.045),),
                              ],
                            ),
                          ),
                        )).toList()
                      ),
                      if(snapshot.data.roles.first.toString() == "null")
                        Center(child: Text("No category Found",style: TextStyle(color: Colors.grey),),)
                    ],
                  ),
                );
              }
            }
            return Center(
              child: LoadingIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Cat> list = [
    Cat(img: Assets.imagesAdmin, title: "Administrator"),
    Cat(img: Assets.imagesDelivery, title: "Delivery"),
    Cat(img: Assets.imagesSalesmanS, title: "Salesman"),
    Cat(img: Assets.imagesWarehouse, title: "Warehouse"),
    Cat(img: Assets.imagesOffice, title: "Office"),
  ];
}

class Cat {
  String img;
  String title;
  Cat({this.img, this.title});
}
