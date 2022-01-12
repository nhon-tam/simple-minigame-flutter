import 'package:flutter/cupertino.dart';

class RoomData {

  RoomData({
    this.id,
    this.name,
    this.timeLeft,
    this.highestScore
  });

  String id;
  String name;
  String timeLeft;
  String highestScore;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'timeLeft': timeLeft,
      'highestScore': highestScore
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
    );
  }

}