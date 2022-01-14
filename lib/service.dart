import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/room_data.dart';
import 'package:flipcard/user_data.dart';

class Service{
  DatabaseReference _db;
  FirebaseAuth _auth;

  Service(DatabaseReference db, FirebaseAuth auth){
    _db = db;

  }

  Future<void> setUserData(String userId, String name, int score, int win, int onlineScore) async {
    final UserData userData = UserData(id: userId, name: name, score: score, win: win, onlineScore: onlineScore);
    await _db.child('users/$userId')
        .set(userData.toMap());
  }

  Future<void> setRoomData(String roomId, String name, int timeLeft, int highestScore, int member) async {
    final RoomData roomData = RoomData(id: roomId, name: name, timeLeft: timeLeft, highestScore: highestScore, member: member, play: false);
    UserData userData;
    getUserData(roomId).then((value){
        userData = value;
    });
    await _db.child('roomdatas/$roomId')
        .set(roomData.toMap());
    await _db.child('rooms/$roomId/$roomId').set({
      "score": 0,
      "name": userData.name,
      "userId": roomId
    });
  }

  Future<void> setRoomPlay(String roomId, bool play) async {
    await _db.child('roomdatas/$roomId')
        .update({
      "play" : play
    });
  }


  Future<RoomData> getRoomData(String roomId) async {
    return await _db.child('roomdatas/$roomId')
        .once()
        .then((result) {
      final LinkedHashMap value = result.snapshot.value;
      return RoomData.fromMap(value);
    });
  }

  Future<List<String>> getRoomList() async{
    DataSnapshot roomsSnapshot;
    await FirebaseDatabase.instance
        .reference()
        .child("rooms")
        .once().then((value){
          roomsSnapshot = value.snapshot;
    });

    List<String> rooms = [];

    Map<dynamic, dynamic> values = roomsSnapshot.value;
    if(values != null){
      values.forEach((key, values) {
        rooms.add(key);
      });
    }
    return rooms;
  }

  Future<DataSnapshot> getRoomScore(String roomId) async{
    DataSnapshot roomsSnapshot;
    await FirebaseDatabase.instance
        .reference()
        .child("rooms/$roomId")
        .once().then((value){
      roomsSnapshot = value.snapshot;
    });
    return roomsSnapshot;
  }

  Future<void> removeRoomData(String roomId) async {
    await _db.child('rooms/$roomId')
        .remove();
    await _db.child('roomdatas/$roomId')
        .remove();
  }



  Future<UserData> getUserData(String userId) async {
    return await _db.child('users/$userId')
        .once()
        .then((result) {
      final LinkedHashMap value = result.snapshot.value;
      return UserData.fromMap(value);
    });
  }



  Future<void> updateUserScore(String userId, int score) async {
    await _db.child('users/$userId')
        .update({
      "score" : score
    });
  }


  Future<bool> checkIfEmailInUse(String emailAddress) async {
    try {
      final list = await _auth.fetchSignInMethodsForEmail(emailAddress);
      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return true;
    }
  }


}