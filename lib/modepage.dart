import 'package:flutter/material.dart';

import 'flipcardgame.dart';

class ModePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ModePage> {

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
              child: GestureDetector(
                  onTap: () {
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
          ]
          ))
      ),
    );
  }
}
