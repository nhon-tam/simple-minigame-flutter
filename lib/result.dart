import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/user_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipcard/auth.dart';
import 'package:flipcard/register.dart';
import'package:firebase_database/firebase_database.dart';
import 'package:flipcard/service.dart';
import 'modepage.dart';

class Result extends StatefulWidget {
  final List<dynamic> listUser;
  Result(this.listUser);
  @override
  _State createState() => _State(this.listUser);
}

class _State extends State<Result> {
  User currentUser;
  UserData userData;
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);

  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;
      service.getUserData(currentUser.uid).then((value){
        userData = value;
      });
    });
  }

  final List<dynamic> listUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var authHandler = new Auth();

  _State(this.listUser);

  Widget _tile(String name, int score) {
    return ListTile(
      title: Text(
          'Tên người chơi: ' + name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(
          'Điểm: $score'
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

  }

}