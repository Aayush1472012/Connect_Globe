import 'package:connect_globe/helper/authenticate.dart';
import 'package:connect_globe/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUser(String email, String pass, BuildContext context) async{
    try{
      FirebaseUser user = await _auth.currentUser();
      AuthCredential credential = EmailAuthProvider.getCredential(email: email, password: pass);

      await user.reauthenticateWithCredential(credential).then((value) {
        value.user.delete().then((result) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Authenticate()));
        });
      });
    }catch(e){
      print(e);
    }
  }
}
