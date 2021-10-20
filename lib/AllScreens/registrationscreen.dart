import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/main.dart';

class RegistrationScreen extends StatefulWidget {
  static const String idScreen = "registrationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static const String idScreen = "registerScreen";
  TextEditingController nameTextEditingController= TextEditingController();
  TextEditingController emailTextEditingController= TextEditingController();

  String dropdownValue="1st";
  final listItem = [
    "1st",
    "2nd",
    "3rd",
    "4th"
  ];
  //TextEditingController confirmPasswordTextEditingController= TextEditingController();
  //TextEditingController passwordTextEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:5.0,),
              Image(
                image: AssetImage ('images/header.png'),
                width: 390.0,
                height: 180.0,
                alignment: Alignment.center,
              ),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child:Column(
                    children: [

                      SizedBox(height:1.0,),
                      TextField(
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

                      SizedBox(height: 10.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Register",
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
                          else if (!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Invalid Email", context);
                          }
                          // else if (passwordTextEditingController.text.length < 6)
                          // {
                          //   displayToastMessage("Password is at least 6 characters", context);
                          //
                          // }
                          // else if (passwordTextEditingController.text!=confirmPasswordTextEditingController.text)
                          // {
                          //   displayToastMessage("Password not match!", context);
                          // }
                          else{
                            registerNewUser(context);
                          }

                        },
                      )


                    ],
                  )
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                    ModalRoute.withName('/'),);

                },
                child: Text(
                  "Already have an Account? Login Here",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {
    String tempPassword="!Q@W#E%T^Y&U*I(O)Pzxc";

    final User? firebaseUser=( await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: tempPassword).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    })).user;

    if (firebaseUser!=null)
    {
      usersRef.child(firebaseUser.uid);
      Map userDataMap={
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "password":tempPassword,
        "year":dropdownValue,
        "isActive":false,
        "photo":"user_icon.png"
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations! Your account has been registered!", context);
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName('/'),);
    }
    else
    {
      displayToastMessage("User has not created!", context);
    }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
