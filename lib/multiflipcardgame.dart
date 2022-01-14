import 'dart:collection';
import 'dart:developer';

import 'package:flip_card/flip_card.dart';
import 'package:flipcard/listroom.dart';
import 'package:flipcard/modepage.dart';
import 'package:flipcard/result.dart';
import 'package:flipcard/room_data.dart';
import 'package:flipcard/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipcard/service.dart';
import 'dart:async';

import 'login.dart';

class MultiFlipCardGame extends StatefulWidget {
  final String roomId;
  MultiFlipCardGame(this.roomId);
  @override
  _FlipCardGameState createState() => _FlipCardGameState(roomId);
}

class _FlipCardGameState extends State<MultiFlipCardGame> {
  User currentUser;
  UserData userData;
  Service service = new Service(FirebaseDatabase().reference(), FirebaseAuth.instance);

  void inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    setState(() {
      currentUser = user;
      service.getUserData(currentUser.uid).then((value){
        userData = value;
      });
    });
  }

  String roomId;

  _FlipCardGameState(this.roomId);

  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;
  RoomData roomData;
  bool _wait = false;
  String name;
  Timer _timer;
  int _time = 5;
  bool _isFinished;
  bool _isPlaying;
  List<String> _data;
  int point = 0;
  int counter = 0;
  bool _couting = true;
  int highestScore = 0;
  LinkedHashMap mapUser;
  List<dynamic> listUser;
  UserData user;
  DataSnapshot snapshot;
  var stt = 0;

  List<bool> _cardFlips;
  List<GlobalKey<FlipCardState>> _cardStateKeys;

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3,
              spreadRadius: 0.8,
              offset: Offset(2.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(4.0),
      child: Image.asset(_data[index]),
    );
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _time = _time - 1;
      });
    });
  }

  incrementCounter() async {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      service.getRoomData(roomId).then((value){
        roomData = value;
      });
      if(!roomData.play){
        setState(() {
          updateFirstUserScore();
          _isFinished = true;
          _timer.cancel();
        });
      }


    });
  }

  void restart() {
    startTimer();
    inputData();
    _data = getSourceArray();
    _cardFlips = getInitialItemState(_data.length);
    _cardStateKeys = getCardKeys(_data.length);
    _time = 2;
    point = 0;
    counter = 0;
    _isFinished = false;
    _isPlaying = true;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _start = true;
        incrementCounter();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    FirebaseDatabase.instance.reference().child('rooms/$roomId/'+ userData.id).update({
      "score" : point
    });
    service.getRoomScore(roomId).then((value){
      snapshot = value;
    });
    service.getRoomData(roomId).then((value){
        roomData = value;
    });
    FirebaseDatabase.instance.reference().child('rooms/'+roomId).onValue.listen((event) {
      setState(() {
        Map<String, dynamic> values = snapshot.value;
        listUser= values.values.toList();
        listUser.sort((b, a) => a['score'].compareTo(b['score']));
        highestScore = listUser[0]['score'];
      });
    });

    FirebaseDatabase.instance.reference().child('roomdatas/'+roomId).onValue.listen((event) {
      setState(() {
        Map<String, dynamic> values = snapshot.value;
        print(values['play']);
        if(values['play'] == false){
          _isFinished = true;
        }
      });
    });

    Widget _tile(String name, int score) {
      return ListTile(
        title: Text(
            'Tên người chơi: ' + name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(
            'Điểm: $score'
        ),
      );
    }

    return _isFinished
        ? Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return _tile(listUser[index]['name'], listUser[index]['score']);
                  },
                  itemCount: listUser.length,
                ),
              ),
              Container(
                margin: EdgeInsets.all(25),
                child: RaisedButton(
                        child: Text("Quay lại", style: TextStyle(fontSize: 20),),
                        onPressed:(){
                          if(userData.id == roomId){
                            Navigator.of(context).pop();
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ListRoom()));
                          }
                        },
                        color: Colors.red,
                        textColor: Colors.yellow,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.grey,
                      )
                ),
            ],
          ),
        ),
      ),
    )
        : Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _time > 0
                    ? Text(
                  '$_time',
                  style: Theme.of(context).textTheme.headline3,
                )
                    : Text(
                  'điểm của bạn: $point',
                  /*this.name+'\'points: $point',*/
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Điểm cao nhất: '+ highestScore.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) => _start
                      ? FlipCard(
                      key: _cardStateKeys[index],
                      onFlip: () {
                        if (!_flip) {
                          _flip = true;
                          _previousIndex = index;
                        } else {
                          _flip = false;
                          if (_previousIndex != index) {
                            if (_data[_previousIndex] != _data[index]) {
                              _wait = true;
                              Future.delayed(
                                  const Duration(milliseconds: 1500),
                                      () {
                                    _cardStateKeys[_previousIndex].currentState.toggleCard();
                                    _previousIndex = index;
                                    _cardStateKeys[index].currentState.toggleCard();
                                    Future.delayed(
                                        const Duration(milliseconds: 160),
                                            () {
                                          setState(() {
                                            _wait = false;
                                          });
                                        });
                                  });
                            } else {
                              _cardFlips[index] = false;
                              _cardFlips[_previousIndex] = false;

                              setState(() {
                                point += 20;
                                if (_cardFlips.every((element) => element == false)) {
                                  print("Won");
                                  Future.delayed(
                                      const Duration(milliseconds: 1500),
                                          () {
                                        setState(() {
                                          _couting = false;
                                          _isFinished = true;
                                          _start = false;
                                          FirebaseDatabase.instance.reference().child('roomdatas/$roomId').update({
                                            "play" : false,
                                          });
                                        });
                                      });
                                }
                              });
                            }
                          }
                        }
                        setState(() {});
                      },
                      flipOnTouch: _wait ? false : _cardFlips[index],
                      direction: FlipDirection.HORIZONTAL,
                      front: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 3,
                                spreadRadius: 0.8,
                                offset: Offset(2.0, 1),
                              )
                            ]),
                        margin: EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/gamepics/quest.png",
                          ),
                        ),
                      ),
                      back: getItem(index))
                      : getItem(index),
                  itemCount: _data.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> updateFirstUserScore() async{
    await service.getUserData(listUser[0]['userId']).then((value){
      user = value;
    });
    var temp = user.win;
    print(temp);
    FirebaseDatabase.instance.reference().child("users/"+listUser[0]['userId']).update(
        {
          'win': temp += 1
        });
  }

}



/**
 * Data
 */
List<String> fillSourceArray() {
  return [
    'assets/gamepics/chrome.png',
    'assets/gamepics/chrome.png',
    'assets/gamepics/msi.png',
    'assets/gamepics/msi.png',
    /*'assets/gamepics/safari.png',
    'assets/gamepics/safari.png',
    'assets/gamepics/dino.png',
    'assets/gamepics/dino.png',
    'assets/gamepics/wolf.png',
    'assets/gamepics/wolf.png',
    'assets/gamepics/peacock.png',
    'assets/gamepics/peacock.png',
    'assets/gamepics/whale.png',
    'assets/gamepics/whale.png',
    'assets/gamepics/octo.png',
    'assets/gamepics/octo.png',
    'assets/gamepics/fish.png',
    'assets/gamepics/fish.png',
    'assets/gamepics/frog.png',
    'assets/gamepics/frog.png',
    'assets/gamepics/seahorse.png',
    'assets/gamepics/seahorse.png',
    'assets/gamepics/girraf.png',
    'assets/gamepics/girraf.png',*/
  ];
}

List getSourceArray() {
  List<String> list = new List<String>();
  List sourceArray = fillSourceArray();
  sourceArray.forEach((element) {
    list.add(element);
  });
  list.shuffle();
  return list;
}

List<bool> getInitialItemState(int left) {
  List<bool> initialItemState = new List<bool>();
  for (int i = 0; i < left; i++) {
    initialItemState.add(true);
  }
  return initialItemState;
}

List<GlobalKey<FlipCardState>> getCardKeys(int left) {
  List<GlobalKey<FlipCardState>> cardKeys = new List<GlobalKey<FlipCardState>>();
  for (int i = 0; i < left; i++) {
    cardKeys.add(GlobalKey<FlipCardState>());
  }
  return cardKeys;
}