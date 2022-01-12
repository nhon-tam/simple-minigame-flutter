import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipcard/auth.dart';
import 'package:flipcard/register.dart';

import 'modepage.dart';

class Profile extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Profile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var authHandler = new Auth();


  @override
  Widget build(BuildContext context) {
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
                      'Người dùng: Tamktpm41',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Kỷ lục chơi đơn: 1000s',
                      style: TextStyle(fontSize: 20),
                    )
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Số trận chơi mạng đã thắng: 12',
                      style: TextStyle(fontSize: 20),
                    )
                ),

                FlatButton(
                  onPressed: (){
                    //forgot password screen
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
                        authHandler.signIn(emailController.text, passwordController.text)
                            .then((User user) {
                          if(user != null){
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => new ModePage()));
                          }
                        }).catchError((e) => print(e));
                      },
                    )),
              ],
            )));
  }
}