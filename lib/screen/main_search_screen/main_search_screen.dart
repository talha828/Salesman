import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salesmen_app_new/api/Auth/online_database.dart';
import 'package:salesmen_app_new/generated/assets.dart';
import 'package:salesmen_app_new/newModel/productModel.dart' as s;
import 'package:salesmen_app_new/newModel/search_product_model.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/select_item_screen/select_item_screen.dart';


class MainSearchScreen extends StatefulWidget {
  const MainSearchScreen({Key key}) : super(key: key);

  @override
  State<MainSearchScreen> createState() => _MainSearchScreenState();
}

class _MainSearchScreenState extends State<MainSearchScreen> {
  bool isLoading = false;
  ProductSearchModel search;
  List<Results> list = [];
  List<Results> searchList = [];
  getSearchRecord() async {
    setLoading(true);
    var response = await OnlineDatabase.getMainSearchProduct();
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      search = ProductSearchModel.fromJson(data);
      for(var i in search.results){
        if(list.where((element) => element.productCode ==i.productCode).isNotEmpty){

        }else{
          list.add(i);
          searchList.add(i);
        }
      }

      // list=search.results.toSet().toList();
      // searchList=search.results.toSet().toList();
      setLoading(false);
    } else {
      Fluttertoast.showToast(msg: "Error: ${data['results'].toString()}");
      setLoading(false);
    }
  }

  filterProducts(String query) {
    setState(() {
      searchList = list
          .where((product) =>
      product.productName.toLowerCase().contains(query.toLowerCase()) ||
          product.productCode.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  setLoading(bool value) => setState(
        () => isLoading = value,
  );
  @override
  void initState() {
    getSearchRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.topRight,
                  begin: Alignment.bottomLeft,
                  colors: <Color>[
                    themeColor1,
                    themeColor1,
                  ]),
            ),
          ),
          title: Text(
            "Search Product",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.04),
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Search Here",
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                      ),
                      onChanged: (query) => filterProducts(query),
                    ),
                  ),
                  SizedBox(height: width * 0.04,),
                  searchList.isNotEmpty
                      ? Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            setLoading(true);
                            var response =
                            await OnlineDatabase.getSingleMainSearchProduct(
                                productCode:
                                searchList[index].productCode)
                                .then((value) {
                              var data = jsonDecode(
                                  utf8.decode(value.bodyBytes));
                              if (value.statusCode == 200) {
                                s.Product product = s.Product.fromJson(data);
                                Get.to(SelectItemScreen(results: product.results.first,));
                                setLoading(false);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Error: ${data["results"]}");
                                setLoading(false);
                              }
                            }).catchError((error) {
                              Fluttertoast.showToast(
                                  msg: "Error: ${error.toString()}");
                              setLoading(false);
                            });
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: searchList[index].image.toString() ==
                                "null"
                                ? Image.asset(Assets.imagesGear)
                                : Image.network(
                              searchList[index].image,
                              width: width * 0.2,
                              height: width * 0.2,
                              fit: BoxFit.fill,
                              errorBuilder:
                                  (context, object, stackTrace) {
                                return Image.asset(Assets.imagesGear);
                              },
                            ),
                          ),
                          title: Text(
                            searchList[index].productName,
                            // maxLines: 1,
                          ),
                          subtitle: Text(
                            searchList[index].description.toString() == "null"?"--":searchList[index].description.toString(),
                          ),
                          trailing:Text(
                            searchList[index].productCode,
                            maxLines: 1,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: searchList.length,
                    ),
                  )
                      : Container()
                ],
              ),
            ),
            isLoading
                ? Positioned.fill(
              child: ProcessLoading(),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
