import 'package:checkschool/MainPage/PartPage/SpecialCircumstance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FirstPage extends StatefulWidget {
  var documents;
  String SchoolName;
  String uid;
  String NetworkCheck;

  FirstPage(this.documents,this.SchoolName,this.uid,this.NetworkCheck);

  @override
  _FirstPageState createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> with AutomaticKeepAliveClientMixin<FirstPage>{
  @override
  bool get wantKeepAlive => true;

  Stream currentStream;
  var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");

  //#region button
  String NowRoom = "자습실";
  //GBS 출석
  List<String> GBSDetailName = ["자습실 or 교실","물리실1","물리실2","화학실1","화학실2",
    "생명실1","생명실2","지구과학실1","지구과학실2","천문대","도서실","음악실",
    "NoteStation2","컴퓨터실1","컴퓨터실2"];
  GBSshowPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff999999),
                      width: 0.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    ),
                    CupertinoButton(
                      child: Text('확인'),
                      onPressed: () {
                        CheckDetail(NowRoom);
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height: 320.0,
                  color: Color(0xfff7f7f7),
                  child:CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        NowRoom= GBSDetailName[value];
                      });
                    },
                    itemExtent: 32.0,
                    children:
                    const [
                      Text("자습실 or 교실"),
                      Text("물리실1"),
                      Text("물리실2"),
                      Text("화학실1"),
                      Text("화학실2"),
                      Text("생명실1"),
                      Text("생명실2"),
                      Text("지구과학실1"),
                      Text("지구과학실2"),
                      Text("천문대"),
                      Text("도서실"),
                      Text("음악실"),
                      Text("NoteStation2"),
                      Text("컴퓨터실1"),
                      Text("컴퓨터실2"),
                    ],
                  )
              )
            ],
          );
        });
  }
  //츨석
  Future CheckDetail(String RoomName) async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":RoomName,"SpecialComment":""});

    setState(() {
    });
  }
  //조기입실
  Future EarlyEnter() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":"조기입실","SpecialComment":""});

    setState(() {
    });
  }
  Future EarlyEnterCancle() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":0,});

    setState(() {
    });
  }
  //특별실 신청
  var ApplyTime = Map();
  Future DeleteApply() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"ApplyDate":0});

    setState(() {
    });
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    ApplyTime = widget.documents["ApplyTime"];

    return Center(
      child: Container(
        width: 700,
        child: ListView(
          children: [
            //사용자 정보
            Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all( Radius.circular(7), ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("출석체크: ",style: TextStyle(fontSize: 20,color: Colors.white)),
                      widget.documents["Date"]==date ?
                      Icon(CupertinoIcons.check_mark,color: Colors.white,) : Icon(CupertinoIcons.xmark,color: Colors.white,),
                      SizedBox(width: 5,),
                      widget.documents["Date"]==date ?
                      Text("출석위치: ${widget.documents["NowLocation"]}",style: TextStyle(fontSize: 20,color: Colors.white)) :
                      Container(),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text("와이파이상태: ${widget.NetworkCheck}",style: TextStyle(fontSize: 20,color: Colors.white)),
                  SizedBox(height: 5,),
                  Text("${widget.documents["Grade"]}${widget.documents["Class"]}${widget.documents["Number"]~/10==0 ? 0:""}${widget.documents["Number"]} ${widget.documents["Name"]}",style: TextStyle(fontSize: 20,color: Colors.white)),
                ],
              ),
            ),

            //CheckIn
            GestureDetector(
              onTap: (){
                var hour = DateTime.now().hour;

                if(!(hour>=18&&hour<=24)){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "6시 이후부터 출석할 수 있습니다.",
                    ),
                  );
                  return;
                }

                if(widget.documents["Date"] == date && widget.documents["NowLocation"] == "조기입실"){
                  EarlyEnterCancle();
                  return;
                }

                EarlyEnter();
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all( Radius.circular(7), ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.documents["Date"] == date && widget.documents["NowLocation"] == "조기입실" ? "조기입실 취소" : "조기입실"}",style:TextStyle(fontSize: 30)),
                    Icon(CupertinoIcons.check_mark)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                var hour = DateTime.now().hour;

                if(!(hour>=18&&hour<=24)){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "6시 이후부터 출석할 수 있습니다.",
                    ),
                  );
                  return;
                }

                if(widget.documents["Date"] == date && widget.documents["NowLocation"] == "조기입실"){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "이미 조기입실 되었습니다.",
                    ),
                  );
                  return;
                }

                setState(() {
                  NowRoom = "자습실";
                });

                switch(widget.SchoolName){
                  case "경기북과학고등학교":
                    GBSshowPicker();
                    break;

                  default:
                    break;
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all( Radius.circular(7), ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.documents["Date"] == date?"현재위치 변경":"출석하기"}",style:TextStyle(fontSize: 30)),
                    Icon(CupertinoIcons.check_mark)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                var hour = DateTime.now().hour;

                if(!(hour>=18&&hour<=24)){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "6시 이후부터 출석할 수 있습니다.",
                    ),
                  );
                  return;
                }

                if(widget.documents["Date"] == date && widget.documents["NowLocation"] == "조기입실"){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "이미 조기입실 되었습니다.",
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpecialCircumstance(widget.SchoolName,widget.uid)),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all( Radius.circular(7), ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("특기사항",style:TextStyle(fontSize: 30)),
                    Icon(CupertinoIcons.check_mark)
                  ],
                ),
              ),
            ),

            /*
                      //특별실 신청
                      !(documents["ApplyDate"]==date) ?
                      GestureDetector(
                        onTap: (){
                          var hour = DateTime.now().hour;
                          if(!(hour<18)){
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message:
                                "6시 이전까지만 신청할 수 있습니다.",
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Put_In_For(widget.SchoolName,widget.uid)),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all( Radius.circular(7), ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("특별실 신청",style:TextStyle(fontSize: 30)),
                              Icon(CupertinoIcons.right_chevron)
                            ],
                          ),
                        ),
                      ) : Container(),
                      documents["ApplyDate"]==date ?
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all( Radius.circular(7), ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Room
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("특별실 신청: ${documents["ApplyRoom"]}",style: TextStyle(fontSize: 20)),
                                documents["BackComment"] == "" ?
                                GestureDetector(
                                  onTap: (){
                                    DeleteApply();
                                  },
                                  child: Icon(CupertinoIcons.delete,color: Colors.black,),
                                ):Container()
                              ],
                            ),
                            SizedBox(height: 10,),
                            //Check TIme
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text("1교시",style: TextStyle(fontSize: 19)),
                                    Checkbox(
                                      value: ApplyTime["First"],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("2교시",style: TextStyle(fontSize: 19)),
                                    Checkbox(
                                      value: ApplyTime["Second"],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("3교시",style: TextStyle(fontSize: 19)),
                                    Checkbox(
                                      value: ApplyTime["Third"],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("4교시",style:TextStyle(fontSize: 19)),
                                    Checkbox(
                                      value: ApplyTime["Forth"],
                                    )
                                  ],
                                )
                              ],
                            ),
                            //Reason
                            Text("신청 이유: ${documents["ApplyComment"]}",style: TextStyle(fontSize: 20)),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey
                            ),

                            //result
                            documents["BackComment"] == "" ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoActivityIndicator(),
                                SizedBox(width: 10,),
                                Text("승인을 대기하는 중",style: TextStyle(fontSize: 20)),
                              ],
                            ) :
                            Row(
                              children: [
                                Text("신청 결과:",style: TextStyle(fontSize: 20)),
                                SizedBox(width: 10,),
                                documents["BackCheck"] ?
                                Icon(CupertinoIcons.check_mark,color: Colors.black,):
                                Icon(CupertinoIcons.xmark,color: Colors.black,),
                              ],
                            ),

                            //Commnet
                            documents["BackComment"] != "" ?
                            Text("의견: ${documents["BackComment"]}",style: TextStyle(fontSize: 20)):Container(),
                          ],
                        ),
                      ) : Container(),
                       */
          ],
        ),
      ),
    );
  }
}
