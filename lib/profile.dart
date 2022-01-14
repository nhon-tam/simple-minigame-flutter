import 'package:firebase_core/firebase_core.dart';
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

class Profile extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Profile> {
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);
  User currentUser;
  UserData userData;

  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    inputData();
    service.getUserData(currentUser.uid).then((value){
      userData = value;
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
                        'Người dùng: '+ userData.name,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Kỷ lục chơi đơn: ' + userData.score.toString(),
                        style: TextStyle(fontSize: 20),
                      )
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Số trận chơi mạng đã thắng: ' + userData.win.toString(),
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
                        child: Text('Quay lại'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                ],
              )));
    }


}