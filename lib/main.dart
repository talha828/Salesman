import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesmen_app_new/model/cart_model.dart';
import 'package:salesmen_app_new/model/customerList.dart';
import 'package:salesmen_app_new/model/new_customer_model.dart';
import 'package:salesmen_app_new/model/user_model.dart';
import 'package:salesmen_app_new/model/wallet_capacity.dart';
import 'package:salesmen_app_new/others/style.dart';
import 'package:salesmen_app_new/screen/MechanicScreen/addMechanicScreen.dart';
import 'package:salesmen_app_new/screen/MechanicScreen/successfully_add_mechanic_screen.dart';
import 'package:salesmen_app_new/screen/mainScreen/mainScreen.dart';
import 'package:salesmen_app_new/screen/splash_screen/get_started_screen.dart';
import 'package:salesmen_app_new/screen/splash_screen/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Add this
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(),
        ),
        ChangeNotifierProvider<NewCustomerModel>(
          create: (_) => NewCustomerModel(),
        ),
        ChangeNotifierProvider<WalletCapacity>(
          create: (_) => WalletCapacity(),
        ),
        ChangeNotifierProvider<CartModel>(
          create: (_) => CartModel(),
        ),
        ChangeNotifierProvider<CustomerList>(
          create: (_) => CustomerList(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(headline1: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white)
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.red,
                showUnselectedLabels: true,
          ),
          bottomAppBarColor: Colors.white,
          primaryColor: themeColor1,
        ),
        home:SplashScreen(),
      ),
    );
  }
}
