import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/slider.dart';

String _topicId="";
List<Pages> _pageData =[];
//int _currentPage = 1;
final _pages= <Widget>[];
class Slides extends StatefulWidget {
  Slides(List<Pages> pages){
    _pages.clear();
    pages.forEach((element) {
      _pages.add(SliderPage(title: element.text,description: element.description ,image: "images/lap.png"));
    });
    //_topicId=id;
    //_currentPage=2;
  }

  @override
  _SlidesState createState() => _SlidesState();

}

class _SlidesState extends State<Slides> {
  int _currentPage = 2;
  PageController _controller = PageController();
  //final _pages= <Widget>[
   // for (int i = 0; i < 10; i++)
   //   SliderPage(title: "Keep"+ i.toString(),description: "desc"+i.toString(),image: "images/lap.png"),

  //];


  @override
  void initState() {
    super.initState();
   // getData();
    _controller = PageController(initialPage: 2);
  }

  void getData() {
    List<Pages> pages=[];
   pagesRef
        .orderByChild("topicId")
        .equalTo(_topicId)
        .once()
        .then((DataSnapshot snapshot){
      // print(snapshot.value);
      // print(snapshot.key);
      snapshot.value.forEach((key,values) {

        Pages page= new Pages(id: key
            , text: values["text"]
            , description: values["description"]
            , sourceType: values["sourceType"]
            , pageImage: values["pageImage"]
            , isActive:  values["IsActive"]=="true"
            , order: int.parse(values["Order"]));


        //print(values);
      });

    }).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    });
  }

  // List<Widget> _pages = [
  //   SliderPage(
  //       title: "Keep",
  //       description:
  //           "Accept cryptocurrencies and digital assets, keep thern here, or send to orthers",
  //       image: "assets/1.svg"),
  //   SliderPage(
  //       title: "Buy",
  //       description:
  //           "Buy Bitcoin and cryptocurrencies with VISA and MasterVard right in the App",
  //       image: "assets/2.svg"),
  //   SliderPage(
  //       title: "Sell",
  //       description:
  //           "Sell your Bitcoin cryptocurrencies or Change with orthres digital assets or flat money",
  //       image: "assets/3.svg"),
  //   SliderPage(
  //       title: "Trade",
  //       description:
  //       "Trade your Bitcoin cryptocurrencies or Change with orthres digital assets or flat money",
  //       image: "assets/3.svg"),
  // ];

  _onchanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onchanged,
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, int index) {
              return _pages[index];
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(_pages.length, (int index) {
                    return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 10,
                        width: (index == _currentPage) ? 30 : 10,
                        margin:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.5)));
                  })),
              InkWell(
                onTap: () {
                  _controller.nextPage(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuint);
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  height: 70,
                  width: (_currentPage == (_pages.length - 1)) ? 200 : 75,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(35)),
                  child: (_currentPage == (_pages.length - 1))
                      ? FlatButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
                        ModalRoute.withName('/'),);

                    },
                    child: Text(
                      "Done",
                    ),
                  )
                      : Icon(
                    Icons.navigate_next,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
