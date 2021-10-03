import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 // database.setPersistenceEnabled(true);
 // database.setPersistenceCacheSizeBytes(10000000);
  User? currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());

}
//FirebaseDatabase database = new FirebaseDatabase();
DatabaseReference usersRef= FirebaseDatabase.instance.reference().child("users");
DatabaseReference topicsRef= FirebaseDatabase.instance.reference().child("topics");


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn and Play',
      theme: ThemeData(
        fontFamily: "Brand-Bold",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.idScreen,
      routes: {
        RegistrationScreen.idScreen:(context)=> RegistrationScreen(),
        LoginScreen.idScreen:(context)=> LoginScreen(),
        MainScreen.idScreen:(context)=> MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


