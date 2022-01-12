import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipcard/config.dart';
import 'dart:async';

class FlipCardGame extends StatefulWidget {
  final String name;
  FlipCardGame(this.name);
  @override
  _FlipCardGameState createState() => _FlipCardGameState(name);
}

class _FlipCardGameState extends State<FlipCardGame> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference _db = FirebaseDatabase().reference();


  _FlipCardGameState(this.name);

  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;

  bool _wait = false;
  String name;
  Timer _timer;
  int _time = 5;
  bool _isFinished;
  List<String> _data;
  int point = 0;

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

  void restart() {
    startTimer();
    _data = getSourceArray();
    _cardFlips = getInitialItemState(_data.length);
    _cardStateKeys = getCardKeys(_data.length);
    _time = 2;
    point = 0;
    _isFinished = false;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _start = true;
        _timer.cancel();
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
    return _isFinished
        ? Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    restart();
                  });
                },
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(25),
                    child: Text(
                      this.name+'\'points: $point',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      "Replay",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ]

              )),
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
                              'Người chơi: '+this.name,
                              /*this.name+'\'points: $point',*/
                              style: Theme.of(context).textTheme.headline3,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Điểm hiện tại của bạn: 120',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Điểm cao nhất hiện tại: 200',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
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
                                                    _isFinished = true;
                                                    _start = false;
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
    'assets/gamepics/safari.png',
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
    'assets/gamepics/girraf.png',
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