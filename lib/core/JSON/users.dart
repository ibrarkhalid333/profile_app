import 'package:meta/meta.dart';
import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? id;
  final String username;
  final String password;
  final String? email;
  final String? phone;
  final String? dob;
  final String? gender;
  final String? imagepath;

  Users({
    this.id,
    required this.username,
    required this.password,
    this.email,
    this.phone,
    this.dob,
    this.gender,
    this.imagepath,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        email: json["email"],
        phone: json["phone"],
        dob: json["dob"],
        gender: json["gender"],
        imagepath: json["imagepath"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "password": password,
        "email": email,
        "phone": phone,
        "dob": dob,
        "gender": gender,
        "imagepath": imagepath,
      };
}
