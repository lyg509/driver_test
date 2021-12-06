import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/test/app.dart';
import 'package:phone_login/test_shop/splashScreen/spalsh_screen.dart';



//test
Future<void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'test',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
        primarySwatch: Colors.blue,

      ),
      home:  MySplashScreen(),
    );
  }
}


