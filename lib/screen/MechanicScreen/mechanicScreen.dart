import 'package:flutter/material.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/MechanicScreen/addMechanicScreen.dart';

class MechanicScreen extends StatefulWidget {
  const MechanicScreen({Key key}) : super(key: key);

  @override
  State<MechanicScreen> createState() => _MechanicScreenState();
}

class _MechanicScreenState extends State<MechanicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: themeColor1,
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMechanicScreen())), label: Text("Add Mechanic"),icon: Icon(Icons.person_add_alt),),
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
                  itemCount: 2,
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
                    child: Image.asset('assets/images/splashlogo.png',
                        scale: 8.5),
                    ),
                    title: Text("Kadeer Mechanic",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    subtitle: Text("+923012070920"),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: index==1?Colors.green:Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      child: Text(index==1?"Approved":"Pending",style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold),),
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
