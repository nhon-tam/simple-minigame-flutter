import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> signUp(email, password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      final User currentUser = await auth.currentUser;
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {

    }
  }

}