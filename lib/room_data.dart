import 'package:flutter/cupertino.dart';

class RoomData {

  RoomData({
    this.id,
    this.name,
    this.timeLeft,
    this.highestScore,
    this.member,
    this.play
  });

  String id;
  String name;
  int timeLeft;
  int highestScore;
  int member;
  bool play = false;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'timeLeft': timeLeft,
      'highestScore': highestScore,
      'member' : member,
      'play' : play
    };
  }

  static RoomData fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return RoomData(
      id: value['id'],
      name: value['name'],
      timeLeft: value['timeLeft'],
      highestScore: value['highestScore'],
      member: value['member'],
      play : value['play']
    );
  }

}