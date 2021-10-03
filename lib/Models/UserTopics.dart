import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class UserTopics
{
  late String? id;
  late String topic;
  late String status;

  UserTopics({required this.id, required this.topic, required this.status,});

  UserTopics.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    topic = dataSnapshot.value["topic"];
    status = dataSnapshot.value["status"];
  }
}