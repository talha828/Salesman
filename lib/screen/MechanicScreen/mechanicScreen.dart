import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salesmen_app_new/model/customerModel.dart';
import 'package:salesmen_app_new/model/mechanicModel.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'addMechanicScreen.dart';


class MechanicScreen extends StatefulWidget {
  CustomerModel customerModel;
  MechanicScreen({this.customerModel});
  @override
  State<MechanicScreen> createState() => _MechanicScreenState();
}

class _MechanicScreenState extends State<MechanicScreen> {
  List<MechanicModel>mechanic=[];
  getMechanic()async{
    var dio=new Dio();
    var response=await dio.get("https://erp.suqexpress.com/api/mechanics/cust/${widget.customerModel.customerCode}");
    for(var i in response.data["data"]){
      mechanic.add(MechanicModel.fromJson(i));
      print(mechanic.last.picture);
    }
    setState(() {
    });
  }

  @override
  void initState() {
    getMechanic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: themeColor1,
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMechanicScreen(customer: widget.customerModel,))), label: Text("Add Mechanic",style: TextStyle(color: Colors.white),),icon: Icon(Icons.person_add_alt,color: Colors.white,),),
      appBar:  MyAppBar(
          title: 'Mechanic',
          ontap: () {
            Navigator.pop(context);
          }),
      body:Container(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return SizedBox(height: 10,);
                },
                  itemCount: mechanic.length,
                  itemBuilder: (context,index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: themeColor1)
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    leading:  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(mechanic[1].picture.toString(),cacheWidth: 100,cacheHeight: 100,
                    errorBuilder: (context,object,StackTrace){
                      return Image.asset('assets/images/splashlogo.png',scale: 8.5,);
                    },
                    ),
                    ),
                    title: Text(mechanic[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    subtitle: Text(mechanic[index].phone.toString()),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: 1==1?Colors.green:Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      child: Text(1==1?"Approved":"Pending",style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold),),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ) ,
    );
  }
}
