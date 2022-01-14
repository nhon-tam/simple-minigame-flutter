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

class Register extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Register> {

  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);
  var authHandler = new Auth();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
                        /*service.checkIfEmailInUse(emailController.text).then((value)
                        {*/
                          /*if(value){
                            showAlertDialog(context);
                          }else{*/
                            authHandler.signUp(emailController.text, passwordController.text)
                                .then((User user) {
                              service.setUserData(user.uid, user.email, 0, 0, 0);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            }).catchError((e) => print(e));
                         /* }*/
                        /*});*/


                      },
                    )
                ),

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
                              Navigator.of(context).pop();
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
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
      content: Text("Tài khoản đã có người sử dụng."),
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

}

