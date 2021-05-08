import 'package:checkschool/MainPage/MainPage/SecondPage.dart';
import 'package:checkschool/MainPage/MainPage/ThirdPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:checkschool/MainPage/MainPage/FirstPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'PartPage/Setting.dart';

class MainPage extends StatefulWidget {
  String NetworkCheck;
  String SchoolName;
  String uid;

  MainPage(this.NetworkCheck,this.SchoolName,this.uid);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin<MainPage>{
  @override
  bool get wantKeepAlive => true;

  Stream currentStream;
  var documents;

  int currentPage = 0;

  Widget NowPage(int page){
    switch(page){
      case 0:
        return FirstPage(documents,widget.SchoolName,widget.uid,widget.NetworkCheck);
      case 1:
        return SecondPage(documents["Grade"],documents["Class"], widget.SchoolName, widget.uid);
      case 2:
        return ThirdPage(widget.SchoolName, widget.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).snapshots();

    return StreamBuilder(
        stream: currentStream,
        builder:(context,snapshot){
          if(snapshot.hasData){
            documents = snapshot.data;
            if(documents["Access"]){
              return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                  actions: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          currentPage = 0;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Menu",style:TextStyle(fontSize: 25,color:currentPage == 0 ? Colors.blue:Colors.black)),
                      )
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          currentPage = 1;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Daily",style:TextStyle(fontSize: 25,color:currentPage == 1 ? Colors.blue:Colors.black)),
                      )
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          currentPage = 2;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Contents",style:TextStyle(fontSize: 25,color:currentPage == 2 ? Colors.blue:Colors.black)),
                      )
                    )
                  ],
                ),
                drawer: Drawer(
                  child: Setting(),
                ),
                body: NowPage(currentPage),
              );
            }else{
              return Scaffold(
                body: Center(child: Text("승인을 대기해주세요",style: TextStyle(fontSize: 20),),),
              );
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