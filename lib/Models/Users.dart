import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class Users
{
  late String? id;
  late String email;
  late String name;
  late String year;

  Users({required this.id, required this.email, required this.name, required this.year,});

  Users.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    year = dataSnapshot.value["year"]??"1st";
  }
}