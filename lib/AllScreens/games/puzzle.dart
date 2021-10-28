import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/GameRanking.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/games/puzzlegame/widgets/Time.dart';
import '../../widget/games/puzzlegame/widgets/Menu.dart';
import '../../widget/games/puzzlegame/widgets/MyTitle.dart';
import '../../widget/games/puzzlegame/widgets/Grid.dart';

String _topic="";
class Puzzle extends StatefulWidget {
  Puzzle(String topic){
    _topic=topic;
  }
  static const String idScreen = "puzzleScreen";
  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int move = 0;

  static const duration = const Duration(seconds: 1);
  int secondsPassed = 0;
  bool isActive = false;
  Timer? timer;
  int seconds = 0,
      minutes = 0,
      hours = 0;

  @override
  void initState() {
    super.initState();
    timer = null;
    numbers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        startTime();
      });
    }

    return SafeArea(
      child: Container(
        height: size.height,
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            MyTitle(size),
            Time(secondsPassed),
            // Time(hours.toString() + ":" + minutes.toString() + ":" +
            //     seconds.toString()),
            Grid(numbers, size, clickGrid),
            Menu(reset, move, secondsPassed, size),
          ],
        ),
      ),
    );
  }

  void clickGrid(index) {
    if (secondsPassed == 0) {
      isActive = true;
    }
    if (index - 1 >= 0 && numbers[index - 1] == 0 && index % 4 != 0 ||
        index + 1 < 16 && numbers[index + 1] == 0 && (index + 1) % 4 != 0 ||
        (index - 4 >= 0 && numbers[index - 4] == 0) ||
        (index + 4 < 16 && numbers[index + 4] == 0)) {
      setState(() {
        move++;
        numbers[numbers.indexOf(0)] = numbers[index];
        numbers[index] = 0;
      });
    }
    checkWin();
  }

  void startTime() {
    if (isActive) {
      setState(() {
        secondsPassed = (secondsPassed + 1);
        // seconds = timer!.tick - (hours * (60 * 60)) - (minutes * 60);
        // minutes = secondsPassed ~/ 60;
        // hours = secondsPassed ~/ (60 * 60);
      });
    }
  }

  void reset() {
    setState(() {
      numbers.shuffle();
      move = 0;
      secondsPassed = 0;
      seconds = 0;
      minutes = 0;
      hours = 0;
      timer=null;
      isActive = false;
    });
  }

  bool isSorted(List list) {
    int prev = list.first;
    for (var i = 1; i < list.length - 1; i++) {
      int next = list[i];
      if (prev > next) return false;
      prev = next;
    }
    return true;
  }

  void checkWin() {
    if (isSorted(numbers)) {
      isActive = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Congratulations! You made it! " ,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 220.0,
                        child: RaisedButton(
                          onPressed: () async {
                            //var rng = new Random();
                           // var code = rng.nextInt(900000) + 100000;

                            Map<String, dynamic> gameRankingMap = {
                              "topic": _topic,
                              "studentId": userCurrentInfo.id,
                              "studentGameId": userCurrentInfo.id.toString() +
                                  "_Puzzle",
                              "student": userCurrentInfo.name.toUpperCase(),
                              //descriptionController.text, //html,
                              "game": "Puzzle",
                              "scoreOrTime": secondsPassed,
                            };

                            var userGameId = userCurrentInfo.id.toString() +
                                "_Puzzle";
                            String rankKey = "";
                            await gameRankingRef.orderByChild("studentGameId")
                                .equalTo(userGameId).once().then((
                                DataSnapshot snapshot) async =>
                            {
                              if (snapshot.value != null){

                                snapshot.value.forEach((key, values) {
                                  rankKey = key;
                                }),
                                await gameRankingRef.child(rankKey).update(
                                    gameRankingMap).then((value) =>
                                {
                                  Navigator.pop(context),
                                })
                              }
                              else
                                {
                                  await gameRankingRef.push()
                                      .set(gameRankingMap)
                                      .then((value) =>
                                  {
                                    // displayToastMessage("Page created!", context),
                                    Navigator.pop(context),
                                  })
                                }
                            });
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }
}
