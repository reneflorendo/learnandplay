import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GameRanking
{
  late String? id;
  late String topic;
  late String studentId;
  late String game;
  late String scoreOrTime;

  GameRanking({required this.id,
    required this.topic,
    required this.studentId,
    required this.game,
    required this.scoreOrTime});

  GameRanking.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    topic = dataSnapshot.value["topic"];
    studentId = dataSnapshot.value["studentId"];
    game = dataSnapshot.value["game"];
    scoreOrTime = dataSnapshot.value["scoreOrTime"];
  }
}