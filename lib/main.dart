import 'package:checkschool/Login/Home_Page.dart';
import 'package:checkschool/Login/SignUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Login/google_sign_in.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'CheckIn',
        theme: ThemeData(
          fontFamily: "SCDream4",
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
