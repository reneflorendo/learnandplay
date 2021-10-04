import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/widget/changepassword.dart';
import 'package:learnandplay/widget/profile.dart';
import 'package:learnandplay/widget/topicscomplete.dart';

class Navigation extends StatelessWidget {
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  final padding = EdgeInsets.symmetric(horizontal: 5);
  @override
  Widget build(BuildContext context) {

    final name ="Rene Florendo";
    final email= "reneflorendo@gmail.com";
    final photo= "https://firebasestorage.googleapis.com/v0/b/learnandplay-bfa40.appspot.com/o/user_icon.png?alt=media&token=d1ea60d2-2bd0-46f5-b49c-56438c2dae14";

    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          padding:padding,
          children: <Widget>[
            buildHeader(
              photo:photo,
              name:name,
              email:email
            ),
            const SizedBox(height:20),
            Divider(color: Colors.white70,thickness: 1,),
            const SizedBox(height: 20),
            buildMenuItem(
              text:"My Account",
              icon:Icons.people,
              onClicked: ()=> selectedItem(context, 0)
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              text:"Change Password",
              icon:Icons.vpn_key,
              onClicked: ()=> selectedItem(context, 1)
            ),
            const SizedBox(height:20),
            buildMenuItem(
              text:"Topics Complete",
              icon:Icons.book,
              onClicked: ()=> selectedItem(context, 2)
            ),
            const SizedBox(height:20),
            Divider(color: Colors.white70,),
            const SizedBox(height: 20),
            buildMenuItem(
                text:"Log out",
                icon:Icons.logout,
                onClicked: ()=> selectedItem(context, 3)
            ),
          ],
        ) ,

      ),
    );
  }
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked
  })
  {
    final color =Colors.white;
    final hoverColor = Colors.red;

    return ListTile(
     leading: Icon(icon, color:color),
    title: Text(text, style: TextStyle(color:color)),
    hoverColor: hoverColor,
    onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index){

    //Navigator.of(context).pop();

    switch (index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePassword()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopicsComplete()));
        break;
      case 3:
        _firebaseAuth.signOut();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Widget buildHeader(
  {
   required String photo,
   required String name,
   required String email
  }) =>
      InkWell(
        child: Container(
        padding:padding.add(EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(photo)),
            SizedBox(width:20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white)
            ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
              ],
            )
          ],
        ),
      )
      );

}
