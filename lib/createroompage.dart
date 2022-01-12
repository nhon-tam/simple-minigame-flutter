import 'package:flutter/material.dart';

import 'flipcardgame.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CreateRoomPage> {
  TextEditingController nameController = new TextEditingController();
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
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập tên phòng chơi'
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FlipCardGame(nameController.text)),
                    );
                  },
                  child: Column(children:<Widget> [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Tạo phòng",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FlipCardGame(nameController.text)),
                    );
                  },
                  child: Column(children:<Widget> [
                    Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Quay lại",
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
