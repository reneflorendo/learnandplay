import 'package:flutter/material.dart';

class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String sourceType;

  SliderPage(
      {required this.title, required this.description, required this.image, required this.sourceType});

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery
    //     .of(context)
    //     .size
    //     .width;

    return getContainerLayout(context,sourceType);
    //
    // return Container(
    //   color: Colors.white,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       SizedBox(),
    //       Html(data: """"<div>Follow<a class='sup'><sup>pl</sup></a>
    //         Below hr
    //         <b>Bold</b>
    //         <h1>what was sent down to you from your Lord</h1>,
    //         and do not follow other guardians apart from Him. Little do
    //         <span class='h'>you remind yourselves</span><a class='f'><sup f=2437>1</sup></a></div>
    //         """,
    //
    //       ),
    //       SizedBox(
    //         height: 60,
    //       ),
    //       Text(
    //         title,
    //         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    //       ),
    //       Image.asset(
    //         image,
    //         width: width * 0.6,
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 80),
    //         child: Text(
    //           description,
    //           style: TextStyle(
    //             height: 1.5,
    //             fontWeight: FontWeight.normal,
    //             fontSize: 14,
    //             letterSpacing: 0.7,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       SizedBox(
    //         height: 60,
    //       ),
    //     ],
    //   ),
    // );


  }
  getContainerLayout(BuildContext context, String sourceType) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    switch (sourceType) {
      case "1":
        return Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Text(
                            description,
                            style: TextStyle(
                              height: 1.5,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              letterSpacing: 0.7,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ]));
        break;
      case "2":
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              image,
              width: width * 0.6,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
        break;
    }
  }
}