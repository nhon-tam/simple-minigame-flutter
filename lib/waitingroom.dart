
import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/room_data.dart';
import 'package:flipcard/user_data.dart';
import 'package:flipcard/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'multiflipcardgame.dart';

class WaitingRoom extends StatefulWidget {
  final String roomId;
  WaitingRoom(this.roomId);
  @override
  _State createState() => _State(roomId);
}

class _State extends State<WaitingRoom> {
  String roomId;

  _State(this.roomId);
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);
  User currentUser;
  UserData userData;
  RoomData roomData;
  int counter = 0;
  bool _couting = true;
  Timer _timer;
  bool play = false;




  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  incrementCounter() async {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (_couting) {
          counter ++;
        } else {
          _timer.cancel();
        }
      });
    });
  }

    @override
    Widget build(BuildContext context) {
      inputData();
      service.getUserData(currentUser.uid).then((value) {
        userData = value;
      });
      service.getRoomData(roomId).then((value) {
        roomData = value;
      });
      if(roomData.play == true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MultiFlipCardGame(roomId)));
      }
      return Scaffold(
          appBar: AppBar(
            title: Text('Minigame Lật hình'),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Tên phòng: ' + roomData.name,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),

                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Số lượng hiện tại: ' + roomData.member.toString(),
                        style: TextStyle(fontSize: 20),
                      )
                  ),

                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Chờ chủ phòng bắt đầu',
                        style: TextStyle(fontSize: 20),
                      )
                  ),


                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Quay lại'),
                        onPressed: () {
                          FirebaseDatabase.instance.reference().child(
                              'rooms/$roomId/' + currentUser.uid).remove();
                          var a = roomData.member--;
                          FirebaseDatabase.instance.reference().child(
                              'rooms/$roomId/').update({
                            'member': a
                          });
                          Navigator.of(context).pop();
                        },
                      )
                  ),
                ],
              ))
      );
    }
  }

