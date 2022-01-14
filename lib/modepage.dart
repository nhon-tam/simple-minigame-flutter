
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flipcard/profile.dart';

import 'package:flipcard/service.dart';

import'package:firebase_database/firebase_database.dart';

import 'package:flipcard/login.dart';

import 'createroompage.dart';
import 'listroom.dart';


class ModePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ModePage> {
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
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListRoom()));
                  },
                  child: Column(children:<Widget> [
                    Container(
                      height: 100,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Tìm phòng",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRoomPage()));
                  },
                  child: Column(children:<Widget> [
                    Container(
                      height: 100,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Tạo phòng",
                        style: TextStyle(
                            color: Colors.black,
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
                      height: 100,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Quay lại",
                        style: TextStyle(
                            color: Colors.black,
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
