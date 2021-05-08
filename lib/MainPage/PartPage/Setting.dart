import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatelessWidget {
  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Setting",style: TextStyle(fontSize: 30,color: Colors.black)),
        actions: [
          IconButton(
            icon:Icon(CupertinoIcons.xmark,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("앱 관련",style: TextStyle(fontSize: 19),),
          ),
          ListTile(
            tileColor: Colors.grey[300],
            leading:Icon(CupertinoIcons.book,color: Colors.black,size: 30,),
            title:Text("사용법",style: TextStyle(fontSize: 24)),
            trailing: Icon(CupertinoIcons.right_chevron,color: Colors.black,),
            onTap: (){
              _launchURL("https://sites.google.com/view/checkingbs/%ED%99%88");
            },
          ),
          ListTile(
            tileColor: Colors.grey[300],
            leading:Icon(CupertinoIcons.xmark,color: Colors.black,size: 30,),
            title:Text("로그아웃",style:TextStyle(fontSize: 24)),
            trailing: Icon(CupertinoIcons.right_chevron,color: Colors.black,),
            onTap: (){
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
            },
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("앱 오류",style: TextStyle(fontSize: 19),),
          ),
          ListTile(
            tileColor: Colors.grey[300],
            leading:Icon(CupertinoIcons.ellipses_bubble,color: Colors.black,size: 30,),
            title:Text("문제점 연락",style: TextStyle(fontSize: 24)),
            trailing: Icon(CupertinoIcons.right_chevron,color: Colors.black,),
            onTap: (){
              _launchURL("https://forms.gle/TBR7869nuakWcKxu7");
            },
          ),
        ],
      )
    );
  }
}
