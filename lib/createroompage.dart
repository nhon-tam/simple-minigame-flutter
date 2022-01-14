import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/hostroompage.dart';
import 'package:flutter/material.dart';
import 'package:flipcard/service.dart';

import 'login.dart';
import 'modepage.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CreateRoomPage> {
  TextEditingController nameController = new TextEditingController();
  DatabaseReference _db = FirebaseDatabase.instance.reference();
  Service service = new Service(FirebaseDatabase.instance.reference(), FirebaseAuth.instance);
  User currentUser;

  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Minigame'),
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập tên phòng chơi'
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: GestureDetector(
                  onTap: () {
                      inputData();
                      service.setRoomData(currentUser.uid, nameController.text, 0, 0, 1);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HostRoomPage(currentUser.uid)));
                  },
                  child: Column(children:<Widget> [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Tạo phòng",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],)

              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Column(children:<Widget> [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Quay lại",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],)

              ),
            ),
          ]
          ))
      ),
    );
  }
}
