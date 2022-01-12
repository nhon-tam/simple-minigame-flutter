import 'package:flutter/material.dart';
import 'package:flipcard/login.dart';
import 'package:flipcard/auth.dart';
import 'package:flipcard/modepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/config.dart';

class Register extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Register> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference _db = FirebaseDatabase().reference();
  var authHandler = new Auth();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sample App'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Minigame Lật hình',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tài khoản',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên hiển thị',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mật khẩu',
                    ),
                  ),
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
                      child: Text('Đăng ký'),
                      onPressed: () {
                        authHandler.signUp(emailController.text, passwordController.text)
                            .then((User user) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ModePage()));
                        }).catchError((e) => print(e));
                      },
                    )),

                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Đã có tài khoản?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}