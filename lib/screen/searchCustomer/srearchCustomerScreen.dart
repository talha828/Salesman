
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/newCustomerModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/widget/customer_card.dart';


class SearchScreen extends StatefulWidget {
  List<CustomerInfo> customerModel;
  SearchScreen({this.customerModel});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int listLength = 0;
  bool _isSearching;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    getAllCustomerData();
    listLength = 3;
  }

  int i = 0;
  List<CustomerInfo> _list = [];
  List<CustomerInfo> customersearchresult = [];
  Future getAllCustomerData() async {
    for (var item in widget.customerModel) {
      if (i < widget.customerModel.length) {
        _list.add(CustomerInfo(
             cUSTCODE:item.cUSTCODE,
         cUSTOMER:item.cUSTOMER,
         cONTACTPERSON:item.cONTACTPERSON,
         cONTACTPERSON2:item.cONTACTPERSON2,
             pHONE1:item.pHONE1,
             pHONE2:item.pHONE2,
             lONGITUDE:item.lONGITUDE,
             lATITUDE:item.lATITUDE,
         cATCD:item.cATCD,
         pARTYCATEGORY:item.pARTYCATEGORY,
         aDDRESS:item.aDDRESS,
         eDITABLE:item.eDITABLE,
         aCTIVE:item.aCTIVE,
         sHOPASSIGNED:item.sHOPASSIGNED,
             bALANCE:item.bALANCE,
        ));

        i++;
      } else {
        print("else work");
      }
    }
    print("customer list " + _list.length.toString());
  }

  final TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeColor2,
          appBar: MyAppBar(
            title: 'Search',
            ontap: () {
              Navigator.pop(context);
            },
            color: themeColor1,
            color2: themeColor2,
          ),
          body: Column(
            children: [
              SizedBox(
                height: height * 0.025,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenpadding),
                child: Stack(
                  children: [
                    RectangluartextFeild(
                      bordercolor: Color(0xffEBEAEA),
                      hinttext: "Search by shop name",
                      containerColor: Color(0xFFFFFF),
                      enableborder: true,
                      cont: _controller,
                      keytype: TextInputType.text,
                      textlength: 25,
                      onChanged: searchOperation,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            'assets/icons/search.png',
                            scale: 3,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              customersearchresult.length != 0 || _controller.text.isNotEmpty
                  ? Expanded(
                child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (_scrollController.position.pixels ==
                          _scrollController.position.maxScrollExtent) {
                        //  double temp=0.01;
                        setState(() {
                          if (listLength + 1 < customersearchresult.length) {
                            listLength += 1;
                          } else {
                            int temp =
                                customersearchresult.length - listLength;
                            listLength = listLength + temp;
                          }
                        });
                        //print('temp value is'+listLength.toString());
                      }
                      if (_scrollController.position.pixels ==
                          _scrollController.position.minScrollExtent) {
                        //  print('start scroll');
                      }
                      return false;
                    },
                    child: DraggableScrollbar.rrect(
                      controller: _scrollController,
                      heightScrollThumb: 48.0,
                      backgroundColor: themeColor1,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemCount: customersearchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenpadding),
                            child: Column(
                              children: [
                              CustomerCard(
                                image:"null" ,
                                height: height,
                                width: width,
                                f:f,
                                menuButton: ['DIRECTIONS', 'CHECK-IN'],
                                code: customersearchresult[index].cUSTCODE,
                                category: customersearchresult[index].pARTYCATEGORY,
                                shopName:customersearchresult[index].cUSTOMER ,
                                address: customersearchresult[index].aDDRESS,
                                name:customersearchresult[index].cONTACTPERSON ,
                                phoneNo:customersearchresult[index].pHONE1 ,
                                lastVisit:"--" ,
                                dues: "0",
                                lastTrans:"--" ,
                                outstanding: customersearchresult[index].bALANCE,
                                shopAssigned:customersearchresult[index].sHOPASSIGNED ,
                                lat: customersearchresult[index].lATITUDE,
                                long: customersearchresult[index].lONGITUDE,
                                //customerData: CustomerInfo,
                                showLoading:(value){
                                  setState(() {
                                    isLoading=value;
                                  });
                                } ,
                              ),
                                // CustomShopContainer(
                                //   height: height,
                                //   width: width,
                                //   customerData: customersearchresult[index],
                                //   //isLoading2: isLoading,
                                //   lat:11.0 ,
                                //   long:11.0 ,
                                //   showLoading: (value) {
                                //     setState(() {
                                //       isLoading = value;
                                //     });
                                //   },
                                // ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )),
              )
                  : Container(),
            ],
          ),
        ),
        isLoading ? Positioned.fill(child: ProcessLoading()) : Container()
      ],
    );
  }

  void searchOperation(String searchText) {
    if (_isSearching != null) {
      customersearchresult.clear();
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i].cUSTOMER;
        String data1 = _list[i].cUSTCODE;

        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          print("search by name");
          customersearchresult.addAll([_list[i]]);
          setState(() {});
        }else if(data1.toLowerCase().contains(searchText.toLowerCase())) {
          print("search by code");
          customersearchresult.addAll([_list[i]]);
          setState(() {});
        }
      }
      print("result is: " + customersearchresult.length.toString());
    }
  }
}
