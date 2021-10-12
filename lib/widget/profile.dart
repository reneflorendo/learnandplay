import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController yearTextEditingController = TextEditingController();
  String dropdownValue="1st";
  User? firebaseUser;
  String userId="";
  File? image;
  final listItem = [
    "1st",
    "2nd",
    "3rd",
    "4th"
  ];

  @override
  void initState() {
    getProfile();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:20.0,),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child:Column(
                    children: [
                      SizedBox(height: 20,),

                      Stack(
                        children: <Widget>[
                          ClipOval(
                            child:Image.file(
                              (image==null) ? File('/images/logo.png'):image!,
                              width:160,
                              height: 160,
                              fit:BoxFit.cover,
                            ),

                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child:InkWell(
                              onTap: (){
                                showModalBottomSheet(context: context
                                    , builder: ((builder)=> bottomSheet())
                                );
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height:20.0,),
                      TextField(
                        enabled: false,
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),
                      SizedBox(height:20.0,),
                      TextField(
                        enabled: true,
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),
                      SizedBox(height:20.0,),
                      Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Year',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: listItem
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )]),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          width: 50,
                          child: Center(
                            child: Text(
                              "Update",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: (){
                          if (nameTextEditingController.text.length < 3)
                          {
                            displayToastMessage("Name must be at least 3 characters", context);
                          }

                          else{
                            updateUser(context);
                          }

                        },
                      )


                    ],
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet()
  {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              FlatButton.icon(
                  onPressed: (){
                    pickImage(ImageSource.camera);
                  }
                  , icon: Icon(Icons.camera)
                  , label: Text("Camera")
              ),
              FlatButton.icon(
                  onPressed: (){
                    pickImage(ImageSource.gallery);
                  }
                  , icon: Icon(Icons.camera)
                  , label: Text("Gallery")
              )
            ],
          )
        ],
      ),

    );
  }
  pickImage(ImageSource source) async
  {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e){
    }
  }
  //
  void updateUser(BuildContext context) async
  {
    if (firebaseUser!=null)
    {
      var uid=firebaseUser!.uid;
      usersRef.child(uid);
      Map<String, dynamic> userDataMap={
        "name":nameTextEditingController.text.trim(),
        "year":dropdownValue,
      };

    await  usersRef.child(uid).update(userDataMap);
      displayToastMessage("Your account has been updated!", context);
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
        ModalRoute.withName('/'),);
    }
    else
    {
      displayToastMessage("User was not updated!", context);
    }
  }

  getProfile() async{
    firebaseUser = FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

    await reference.once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
      {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
        emailTextEditingController.value= TextEditingValue(text:userCurrentInfo.email);
        nameTextEditingController.value= TextEditingValue(text:userCurrentInfo.name);

        setState(() {
          dropdownValue= userCurrentInfo.year;
        });

      }
    });
  }

  DropdownMenuItem<String> buildMenuItem(String item)  => DropdownMenuItem(
      value:item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));


}
