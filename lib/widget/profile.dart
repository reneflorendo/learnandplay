import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
class Profile extends StatelessWidget {

  
 // userRef.child(rideRequestId).once().then((DataSnapshot dataSnapShot)
 // {
//  if(dataSnapShot.value != null)
//  {
//  }
//  }
  @override
  Widget build(BuildContext context) {

    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
      {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });


    return Scaffold(
      appBar:AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      )
    );
  }
}
