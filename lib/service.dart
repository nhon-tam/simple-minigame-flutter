import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flipcard/auth.dart';
import 'package:flipcard/modepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flipcard/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipcard/user_data.dart';
import 'package:flipcard/room_data.dart';

class FirebaseRealtimeDataService {

  DatabaseReference _db;
  final config = Configurations();
  FirebaseAuth _auth;

  FirebaseRealtimeDataService(FirebaseApp firebaseApp) {
    _db = FirebaseDatabase(
        app: firebaseApp,
        databaseURL: config.databaseURL
    ).reference();
    _auth = FirebaseAuth.instance;
  }

  Future<void> setUserData(String userId, String name, String score) async {
    final UserData userData = UserData(id: userId, name: name, score: score);
    await _db.child('users/$userId')
        .set(userData.toMap());

  }

  Future<void> updateUserData(String name, String score) async {
    final uid = _auth.currentUser.uid;
    final UserData userData = UserData(id: uid, name: name, score: score);
    await _db.child('users/$uid')
        .update(userData.toMap());
  }

  Future<UserData> getUserData() async {
    final uid = _auth.currentUser.uid;
    return await _db.child('users/$uid')
        .once()
        .then((result) {
      final LinkedHashMap value = result.snapshot.value;
      return UserData.fromMap(value);
    });
  }

  Future<void> setRoom(String userId,  String roomId, String name, String timeLeft, String highestScore) async {
    final RoomData userData = RoomData(id: roomId, name: name, highestScore: highestScore, timeLeft: timeLeft );
    await _db.child('rooms/$roomId')
        .set(userData.toMap());
  }

  Future<void> removeRoom(String roomId) async {
    await _db.child('rooms/$roomId')
        .remove();
  }

  /*  Future<void> setRoomData(String userId,  String roomId, String name, String timeLeft, String highestScore) async {
      final RoomData userData = RoomData(id: roomId, name: name, highestScore: highestScore, timeLeft: timeLeft );
      await _db.child('rooms/$roomId')
          .set(userData.toMap());
    }

    Future<void> updateRoomData(String name, String score) async {
      final uid = _auth.currentUser.uid;
      final UserData userData = UserData(id: uid, name: name, score: score);
      await _db.child('users/$uid')
          .update(userData.toMap());
    }

    Future<UserData> getRoomData() async {
      final uid = _auth.currentUser.uid;
      return await _db.child('users/$uid')
          .once()
          .then((result) {
        final LinkedHashMap value = result.snapshot.value;
        return UserData.fromMap(value);
      });
    }

      Future<void> removeUserData(String roomId) async {
        await _db.child('rooms/$roomId')
            .remove();
      }*/

}



