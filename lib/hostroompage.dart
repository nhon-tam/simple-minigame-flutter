import 'package:firebase_core/firebase_core.dart';
import 'package:flipcard/room_data.dart';
import 'package:flutter/material.dart';
import 'package:flipcard/login.dart';
import 'package:flipcard/auth.dart';
import 'package:flipcard/modepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/config.dart';
import 'package:flipcard/user_data.dart';
import 'package:flipcard/service.dart';


import 'modepage.dart';
import 'multiflipcardgame.dart';

class HostRoomPage extends StatefulWidget {
  final String roomId;
  HostRoomPage(this.roomId);
  @override
    _State createState() => _State(roomId);
  }

class _State extends State<HostRoomPage> {


  _State(this.roomId);
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);
  User currentUser;
  UserData userData;
  RoomData roomData;
  String roomId;


  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;

    });
    print(roomId);
  }

  @override
  Widget build(BuildContext context) {
    inputData();
    service.getUserData(currentUser.uid).then((value){
      userData = value;
    });
    service.getRoomData(userData.id).then((value){
      roomData = value;
    });
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
                      'Tên phòng: '+ roomData.name,
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

                FlatButton(
                  onPressed: (){

                  },
                  textColor: Colors.blue,
                  child: Text(''),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Bắt đầu'),
                      onPressed: () {
                          if(roomData.member < 2){
                              showAlertDialog(context);
                          }
                          else{
                            service.setRoomPlay(roomData.id, true);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MultiFlipCardGame(roomId)));
                          }
                      },
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
                        service.removeRoomData(roomData.id);
                      },
                    )
                ),
              ],
            )));
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
    content: Text("Phải ít nhất 2 người mới bắt đầu trò chơi"),
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