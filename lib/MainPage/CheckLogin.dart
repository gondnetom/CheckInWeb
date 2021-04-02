import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainMenu.dart';
import 'Setting.dart';
import 'Signup.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}
class _CheckState extends State<Check> {
  @override
  initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
      });
    });
  }
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  bool first = true;
  var _currentPage = 0;
  var subscription;

  String SchoolName;
  var uid;
  Future CheckStates() async{
    var list = Map();

    //check wifi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      list["Network"] = "모바일 연결됨";
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      list["Network"] = "연결됨";
    }else{
      list["Network"] = "None";
    }

    //check my id
    if(first && list["Network"] != "None"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      SchoolName = await prefs.getString("SchoolName");
      uid = await FirebaseAuth.instance.currentUser.uid;

      final snapShot = await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).get();
      if (snapShot == null || !snapShot.exists) {
        setState(() {
          _currentPage = 1;
        });
      }else{
        first = false;
        setState(() {
          _currentPage = 0;
        });
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("${_currentPage==0 ?"Menu":"SignUp"}",style:TextStyle(fontSize: 30,color: Colors.black)),
      ),
      body: FutureBuilder(
          future: CheckStates(),
          builder:(context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data["Network"] == "None"){
                return Center(child: Text("인터넷을 연결해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),));
              }else{
                if(_currentPage==0)
                  return MainPage(snapshot.data["Network"],SchoolName,uid);
                else
                  return SignUp(SchoolName,uid);
              }
            }else{
              return Center(child: CupertinoActivityIndicator());
            }
          }
      ),
      endDrawer: Drawer(
        child: Setting(),
      ),
    );
  }
}