import 'package:checkschool/Login/Home_Page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Login/google_sign_in.dart';

String browserName;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;

  browserName = webBrowserInfo.browserName.toString();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
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
        home: browserName == "BrowserName.chrome" ?
        HomePage():
        Scaffold(
          body: Center(child: Text("컴퓨터 크롬으로 접속해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),)),
        ),
      ),
    );
  }
}
