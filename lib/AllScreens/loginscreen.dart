import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationScreen.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "loginScreen";
  List<Topics> _topics=[];
  List<Pages> _pages=[];
  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();



  @override
  Widget build(BuildContext context) {
    // Map pageMap={
    //   "topicId":"-MkuV1UjWaOgY8PQii8-",
    //   "text":"About List",
    //   "description": "List<T> class represents the list of objects which can be accessed by index. It comes under the System.Collection.Generic namespace.",
    //   "pageImage":"",
    //   "sourceType":"",
    //   "Order":"1",
    //   "IsActive":"1",
    // };
    //
    // pagesRef.push().set(pageMap);
   // getData(context);

    // topicsRef.once().then(( DataSnapshot dataSnapshot){
    //   topics.clear();
    //   var keys = dataSnapshot.value.keys;
    //   var values = dataSnapshot.value;
    //   for(var key in keys)
    //     {
    //       var pages= values[key]["pages"];
    //
    //
    //
    //       Topics topic=new Topics(
    //           id: dataSnapshot.key,
    //           title: values[key]['title'],
    //           duration: values[key]["duration"],
    //           icon: values[key]["icon"],
    //           pages: null);
    //
    //       topics.add(topic);
    //     }
    // }).catchError((errMsg){
    //   displayToastMessage("Error"+errMsg, context);
    // });

    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height:35.0,),
              Image(
                image: AssetImage ('images/header.png'),
                width: 390.0,
                height: 180.0,
                alignment: Alignment.center,
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child:Column(
                    children: [

                      SizedBox(height:1.0,),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 14.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),

                      SizedBox(height:1.0,),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 14.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),

                      SizedBox(height: 10.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: (){

                          if (!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Invalid EMail", context);
                          }
                          else if (passwordTextEditingController.text.length < 6)
                          {
                            displayToastMessage("Password is at least 6 characters", context);
                          }
                          else{
                            loginAndAuthenticateUser(context);
                          }

                        },
                      )


                    ],
                  )
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (BuildContext context) => RegistrationScreen()),
                    ModalRoute.withName('/'),);
                },
                child: Text(
                  "Do not have an Account? Register Here",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

   // void getData(BuildContext context) async{
   //   topicsRef.once().then((DataSnapshot snapshot){
   //     print(snapshot.value);
   //     print(snapshot.key);
   //     snapshot.value.forEach((key,values) {
   //
   //       Map<String, dynamic> data = new Map<String, dynamic>.from(values["pages"]);
   //       data.forEach((key, values) {
   //          Pages page= new Pages(id: key
   //              , text: values["text"]
   //              , description: values["description"]
   //              , sourceType: values["sourceType"]
   //              , pageImage: values["pageImage"]
   //              , isActive:  values["IsActive"]=="true"
   //              , order: int.parse(values["Order"]));
   //          _pages.add(page);
   //       });
   //
   //       Topics topic=new Topics(
   //           id: key,
   //           title: values['title'],
   //           duration: values["duration"],
   //           icon: values["icon"],
   //           pages: _pages);
   //
   //       _topics.add(topic);
   //       //print(values);
   //     });
   //
   //     var data =_topics;
   //   }).catchError((errMsg){
   //       displayToastMessage("Error"+errMsg, context);
   //     });
   // }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async{

    // Map pageMap={
    //   "topicId":"-MkuP45mdhSr6d2dxwwt",
    //   "text":"About Array",
    //   "description": "An array is a group of like-typed variables that are referred to by a common name",
    //   "pageImage":"array.png",
    //   "sourceType":"1",
    //   "Order":"1",
    //   "IsActive":"1",
    // };
    //
    // pagesRef.push().set(pageMap);
    //topicsRef.child("-MkuW_3qta9F_S2lKtxx").child("pages").push().set(pageMap);
    // Map topicDataMap={
    //   "title":"Queue",
    //   "duration":"15 Minutes",
    //   "icon":"queue.png"
    // };

    // var ref=topicsRef.push();
    // var uniqueKey= ref.key;
    // ref.set(topicDataMap) .then((_) {
    //     topicsRef.child(uniqueKey).child("pages").push().set(pageMap);
    //   return true;
    // }).catchError((onError) {
    //   return false;
    // });

    final User? firebaseUser=( await _firebaseAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    })).user;

    if (firebaseUser!=null)
    {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value !=null)
        {
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
            ModalRoute.withName('/'),);
          displayToastMessage("You are logged in!.", context);
        }
        else
        {
          _firebaseAuth.signOut();
          displayToastMessage("User not exists! Please register.", context);
        }
      });

    }
    else
    {
      _firebaseAuth.signOut();
      displayToastMessage("Cannot sign in!", context);
    }

  }
}
