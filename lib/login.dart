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
import 'package:flipcard/register.dart';
import 'package:flipcard/profile.dart';
import 'flipcardgame.dart';
import 'modepage.dart';

class Login extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Login> {
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User currentUser;
  var authHandler = new Auth();

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
      return !(currentUser != null)?
        Scaffold(
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
                        'Đăng nhập',
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
                        child: Text('Đăng nhập'),
                        onPressed: () {
                          authHandler.signIn(emailController.text, passwordController.text)
                              .then((User user) {
                            if(user != null){
                              setState(){

                              };
                            }
                            else{
                              showAlertDialog(context);
                            }
                          }).catchError((e) => print(e));
                        },
                      )),
                  Container(
                      child: Row(
                        children: <Widget>[
                          Text('Chưa có tài khoản?'),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                ],
              ))):
      MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Minigame'),
            ),
            body: Center(child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ModePage()));
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
                          "Chơi mạng",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FlipCardGame(currentUser.email)));
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
                          "Chơi đơn",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Column(children:<Widget> [
                      Container(
                        height: 100,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "Thống kê",
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
                      setState(() {
                        FirebaseAuth.instance.signOut();
                      });
                    },
                    child: Column(children:<Widget> [
                      Container(
                        height: 100,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "Đăng xuất",
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
    content: Text("Mật khẩu hoặc tài khoản không đúng."),
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