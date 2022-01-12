import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipcard/auth.dart';
import 'package:flipcard/register.dart';

import 'modepage.dart';

class Result extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Result> {
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
                      'Top 1: Tamktpm41',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Top 2: quiktpm41',
                      style: TextStyle(
                          color: Color.fromARGB(255, 211, 211, 211),
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Top 3: nhanktpm41',
                      style: TextStyle(
                          color: Color.fromARGB(255, 205, 107, 50),
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
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