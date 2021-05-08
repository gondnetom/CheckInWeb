import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainMenu.dart';
import 'Signup.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}
class _CheckState extends State<Check> {
  bool first = true;
  int _currentPage = 0;

  String uid;
  String SchoolName;
  Future CheckStates() async{
    var list = Map();

    uid = await FirebaseAuth.instance.currentUser.uid;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    SchoolName = await prefs.getString("SchoolName");
    if(SchoolName == ""){
      await FirebaseAuth.instance.signOut();
      return;
    }

    //#regioncheck wifi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      list["Network"] = "모바일 연결됨";
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      list["Network"] = "연결됨";
    }else{
      list["Network"] = "None";
    }
    //#endregion
    //#regioncheck my id
    if(first && list["Network"] != "None"){

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
    //#endregion

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CheckStates(),
        builder:(context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data["Network"] == "None"){
              return Scaffold(
                body: Center(child: Text("인터넷을 연결해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),)),
              );
            }else{
              if(_currentPage==0)
                return MainPage(snapshot.data["Network"],SchoolName,uid);
              else
                return SignUp(SchoolName,uid);
            }
          }else{
            return Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          }
        }
    );
  }
}