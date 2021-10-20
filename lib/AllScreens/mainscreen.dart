// ignore_for_file: unused_label

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/arraygame.dart';
import 'package:learnandplay/AllScreens/listgame.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/slides.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/Models/UserTopics.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/navigation.dart';

class MainScreen  extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Topics> _topics=[];
  List<Pages> _pages=[];

  @override
  void initState() {
    getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Navigation(),
        appBar: AppBar(
          title: Text("Data Structure"),
        ) ,
        body: ListView.builder(
            itemCount: _topics.length,
            itemBuilder: (context, index){
              Topics topic= _topics[index];
              return Container(
                  height: 170,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text(
                              topic.title,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              topic.duration,
                              style: const TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                            Text(
                                topic.status,
                              style: const TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                  width: 3,
                                ),
                                RaisedButton(
                                  color:Colors.blue,
                                  textColor: Colors.white,
                                  child: Container(
                                    height: 20.0,
                                    child: Center(
                                      child: Text(
                                        (topic.status=="Complete") ?"Retake" :"Learn",
                                        style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                                      ) ,
                                    ),
                                  ),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(24.0)
                                  ),
                                  onPressed: (){

                                    getCurrentTopicPage(userCurrentInfo.id, topic.id,topic.title, topic.status);

                                   },
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 3,
                                ),
                                RaisedButton(
                                  color: topic.gameId >0? Colors.blue :Colors.grey,
                                  textColor: Colors.white,
                                  child: Container(
                                    height: 20.0,
                                    child: Center(
                                      child: Text(
                                        "Play",
                                        style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                                      ) ,
                                    ),
                                  ),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(24.0)
                                  ),
                                  onPressed: (){
                                    if (topic.gameId >0) {
                                      getGame(context, topic.gameId);
                                    }

                                  },
                                ),
                              ],
                            )

                          ],
                        ),
                        Image.network(
                          topic.url!,//"https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                          fit: BoxFit.fill,
                          width: 90,
                          height: 80,
                        )
                      ],
                    ),
                  ));
            }
        )
    );
  }
  void getGame(BuildContext context, int gameId){

    //Navigator.of(context).pop();

    switch (gameId){
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArrayGame()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListGame()));
        break;
      default: {
       displayToastMessage("Game not available yet!", context);
      }
      break;

    }
  }

  int getCurrentTopicPage(String? userId, String topicId, String topic, String topicStatus)
  {
    final userTopicId = userId.toString()+"_"+ topicId;
    final filterField="userId_topicId";
    int currentPage =0;
    String topicKey="";
      Map<String, dynamic> studentTopic={
      "userTopicId":userTopicId,
      "topic":topic,
      "currentPage":0,
      "status":"In Progress",
    };

    studentTopicsRef
        .orderByChild("userTopicId")
        .equalTo(userTopicId)
        .once().then((DataSnapshot dataSnapshot) => {

          if (dataSnapshot.value!=null)
            {
              dataSnapshot.value.forEach((key,values) {

                currentPage=values["currentPage"];
                topicKey=key;
                 // userTopic= new UserTopics(id: key,
                 //    userTopicId: values["userTopicId"],
                 //    topic: values["topic"],
                 //    currentPage: values["currentPage"],
                 //    status: values["status"]);

              }),

                  setState(() {
                        currentPage = (topicStatus=="Complete")?0: currentPage;
                        getPages(topicId,currentPage,topicKey,topic);
                      }),

            }
          else{

            topicKey =studentTopicsRef.push().key,
            studentTopicsRef.child(topicKey).set(studentTopic),
            setState(() {
                  currentPage=0;
                  getPages(topicId, currentPage,topicKey,topic );
            }),

          }
   });

    return currentPage;
  }
  void getPages(String topicId, int index, String topicKey,topic) {
        _pages.clear();
       pagesRef
        .orderByChild("topicId")
        .equalTo(topicId)
        .once()
        .then((DataSnapshot snapshot){
        snapshot.value.forEach((key,values) {

        Pages page= new Pages(id: key
            , text: values["text"]
            , description: values["description"]
            , sourceType: values["sourceType"]
            , pageImage: values["pageImage"]
            , isActive:  values["IsActive"]=="true"
            , topicId:  values["topicId"]
            , order: int.parse(values["Order"])
        );

        _pages.add(page);
      });
      // Navigator.pushAndRemoveUntil(context,
      //   MaterialPageRoute(builder: (BuildContext context) =>  Slides(_pages, index,topicId,topicKey,topic)),
      //   ModalRoute.withName('/'),);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Slides(_pages, index,topicId,topicKey,topic)));
    });
  }

  void getData(BuildContext context) async{
    List<Topics> topics=[];
    List<Pages> pg=[];
    await topicsRef.orderByChild("isActive").equalTo(true) .once().then((DataSnapshot snapshot){
         snapshot.value.forEach((key,values) async {
           Topics topic=new Topics(
            id: key,
            title: values['title'],
            duration: values["duration"],
            icon: values["icon"],
            gameId:values['gameId'],
            status:"",
           );

           await getStatus(userCurrentInfo.id,topic.id).then((value) => {
             topic.status=value.toString().length==0?"Not Started":value.toString()
           });

           Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(topic.icon);
           await firebaseStorageRef.getDownloadURL().then((value) => {
             topic.url = value
           });
         setState(() {
           topics.add(topic);
         });
      });
      setState(() {
        _topics=topics;
      });
    }).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    });
  }

  Future<String> getStatus(String? userId,String topicId) async
  {
    String status="";
    final userTopicId = userId.toString()+"_"+ topicId;
    await studentTopicsRef
        .orderByChild("userTopicId")
        .equalTo(userTopicId)
        .once().then((DataSnapshot dataSnapshot) => {

      if (dataSnapshot.value!=null)
        {
          dataSnapshot.value.forEach((key,values) {

            status=values["status"];

          }),

          setState(() {
            status = status;

          }),

        }

    }
    );
    return status;
  }
}
