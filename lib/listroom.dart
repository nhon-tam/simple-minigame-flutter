import 'dart:developer';

import 'package:flip_card/flip_card.dart';
import 'package:flipcard/hostroompage.dart';
import 'package:flipcard/room_data.dart';
import 'package:flipcard/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipcard/service.dart';
import'package:flipcard/waitingroom.dart';

import 'dart:async';

import 'login.dart';
import 'multiflipcardgame.dart';

class ListRoom extends StatefulWidget {

  @override
  _FlipCardGameState createState() => _FlipCardGameState();
}

class _FlipCardGameState extends State<ListRoom> {
  User currentUser;
  UserData userData;
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);
  List<String> listRoom;
  RoomData roomData;

  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }



  Widget _tile(String title, String subtitle, String id) {

    return ListTile(
      title: Text(
          'Tên phòng: '+title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(
          'Số lượng người chơi: '+subtitle
      ),
      onTap: () {
        if(currentUser.uid == id){
          print('id cua phong $id');
          Navigator.push(context, MaterialPageRoute(builder: (context) => HostRoomPage(id)));
        }
        else{
          if(roomData.play){
              showAlertDialog(context);
          }else{
            FirebaseDatabase.instance.reference().child('rooms/$id/'+currentUser.uid).set({
              'score': 0,
              'name' : currentUser.email,
              'userId': currentUser.uid,
            });
            service.getRoomData(id).then((value){
                value.member++;
                FirebaseDatabase.instance.reference().child('roomdatas/$id').update(value.toMap());
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => WaitingRoom(id)));
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    inputData();
    service.getRoomList().then((value) {
      listRoom = value;
    });
    if(mounted){
    /*var subscription = FirebaseDatabase.instance.reference()
        .child('rooms').onChildAdded
        .listen((event) {
      setState((){
        Map<dynamic, dynamic> values = event.snapshot.value;
        values.forEach((key, values) {
          listRoom.add(Room.fromMap(values));
        });
      });
    });*/
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    Text(
                    'Tìm phòng',
                    style: Theme.of(context).textTheme.headline3,
                )
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    service.getRoomData(listRoom[index]).then((value){
                      roomData = value;
                    });
                      return _tile(roomData.name, roomData.member.toString(), roomData.id);
                  },
                  itemCount: listRoom.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Thông báo"),
    content: Text("Phòng đang chơi, bạn không thể tham gia."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}