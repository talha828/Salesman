import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:salesmen_app_new/others/common.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/MechanicScreen/successfully_add_mechanic_screen.dart';

class AddMechanicScreen extends StatefulWidget {
  const AddMechanicScreen({Key key}) : super(key: key);

  @override
  State<AddMechanicScreen> createState() => _AddMechanicScreenState();
}

class _AddMechanicScreenState extends State<AddMechanicScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController idCard = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Scaffold(
      appBar: MyAppBar(
          title: 'Add Mechanic',
          ontap: () {
            Navigator.pop(context);
          }),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DottedBorder(
                    color: Color(0xffE5E5E5), //color of dotted/dash line
                    strokeWidth: 1.5, //thickness of dash/dots
                    dashPattern: [8, 4],
                    child: Container(
                      height: height * 0.20,
                      width: width * 0.42,
                      color: Color(0xffE5E5E5),
                      child: GestureDetector(
                          onTap: () {
                            // _uploadImg(true);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/camera.png",
                                scale: 3.5,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              VariableText(
                                text: "Camera",
                                fontsize: 13,
                                weight: FontWeight.w400,
                                fontcolor: textcolorblack,
                                fontFamily: fontRegular,
                              ),
                            ],
                          )),
                    )),
                Spacer(),
                //dash patterns, 10 is dash width, 6 is space width
                DottedBorder(
                    color: Color(0xffE5E5E5), //color of dotted/dash line
                    strokeWidth: 1.5, //thickness of dash/dots
                    dashPattern: [8, 4],
                    child: Container(
                      height: height * 0.20,
                      width: width * 0.42,
                      color: Color(0xffE5E5E5),
                      child: GestureDetector(
                          onTap: () {
                            // _uploadImg(false);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/gallery.png",
                                scale: 3.5,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              VariableText(
                                text: "Gallery",
                                fontsize: 13,
                                weight: FontWeight.w400,
                                fontcolor: textcolorblack,
                                fontFamily: fontRegular,
                              ),
                            ],
                          )),
                    )),
              ],
            ),
            MyTextFields(
              title: "Mechanic Name",
              controller: name,
              hint: "Ahsan Iqbal",
            ),
            MyTextFields(
              title: "Mechanic Phone Number",
              controller: phoneNo,
              hint: "+923012071090",
            ),
            MyTextFields(
              title: "Mechanic ID Card No",
              controller: idCard,
              hint: "42301-2563-7894-3",
            ),
            Spacer(),
            MyButton(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SucessFullyMechanicAddScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
