import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
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
        appBar: AppBar(
          title: Text("Data Structure"),
        ) ,
        body: ListView.builder(
            itemCount: _topics.length,
            itemBuilder: (context, index){
              Topics topic= _topics[index];
              return Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //
                        //   children: <Widget>[
                        //     Text(
                        //       topic.title,
                        //       style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        //     ),
                        //     Text(
                        //       topic.duration,
                        //       style: const TextStyle(fontSize: 17, color: Colors.grey),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //
                        //       children: <Widget>[
                        //         SizedBox(
                        //           height: 10,
                        //           //width: 20,
                        //         ),
                        //         RaisedButton(
                        //           color:Colors.blue,
                        //           textColor: Colors.white,
                        //           child: Container(
                        //             height: 50.0,
                        //             child: Center(
                        //               child: Text(
                        //                 "Learn",
                        //                 style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                        //               ) ,
                        //             ),
                        //           ),
                        //           shape: new RoundedRectangleBorder(
                        //               borderRadius: new BorderRadius.circular(24.0)
                        //           ),
                        //           onPressed: (){
                        //             // Navigator.pushAndRemoveUntil(context,
                        //             //   MaterialPageRoute(builder: (BuildContext context) => Landing()),
                        //             //   ModalRoute.withName('/'),);
                        //
                        //           },
                        //         ),
                        //         SizedBox(
                        //           height: 10,
                        //           //width: 20,
                        //         ),
                        //         RaisedButton(
                        //           color:Colors.blue,
                        //           textColor: Colors.white,
                        //           child: Container(
                        //             height: 50.0,
                        //             child: Center(
                        //               child: Text(
                        //                 "Play1",
                        //                 style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                        //               ) ,
                        //             ),
                        //           ),
                        //           shape: new RoundedRectangleBorder(
                        //               borderRadius: new BorderRadius.circular(24.0)
                        //           ),
                        //           onPressed: (){
                        //             // Navigator.pushAndRemoveUntil(context,
                        //             //   MaterialPageRoute(builder: (BuildContext context) => Landing()),
                        //             //   ModalRoute.withName('/'),);
                        //
                        //           },
                        //         ),
                        //       ],
                        //     )
                        //
                        //   ],
                        // ),
                        Image.asset(
                          "images/lap.png",
                          height: double.infinity,
                        )
                      ],
                    ),
                  ));
              // return Card(
              //   child: ListTile(
              //     title: Text(topic.title),
              //     trailing: Icon(Icons.arrow_forward_rounded),
              //   ),
              // );
            }
        )
    );
  }

  void getData(BuildContext context) async{
    List<Topics> topics=[];
    await topicsRef.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      print(snapshot.key);
      snapshot.value.forEach((key,values) {

        Map<String, dynamic> data = new Map<String, dynamic>.from(values["pages"]);
        data.forEach((key, values) {
          Pages page= new Pages(id: key
              , text: values["text"]
              , description: values["description"]
              , sourceType: values["sourceType"]
              , pageImage: values["pageImage"]
              , isActive:  values["IsActive"]=="true"
              , order: int.parse(values["Order"]));
          _pages.add(page);
        });

        Topics topic=new Topics(
            id: key,
            title: values['title'],
            duration: values["duration"],
            icon: values["icon"],
            pages: _pages);

        topics.add(topic);
        //print(values);
      });
      setState(() {
        _topics=topics;
      });
    }).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    });
  }
}