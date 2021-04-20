import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_globe/helper/authenticate.dart';
import 'package:connect_globe/helper/constants.dart';
import 'package:connect_globe/services/auth.dart';
import 'package:connect_globe/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connect_globe/services/auth.dart';

class ChatSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
        'PROFILE',
        style: TextStyle(color: Colors.white,fontSize: 25.0,),
    ),
        ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = Constants.myName;
  String userEmail = Constants.myEmail;
  TextEditingController passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 40, horizontal: 130),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Text(userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget> [
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Parsonal Information',
                                style: TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget> [
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Username : ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          new Column(
                            children: <Widget>[
                              new Text(
                                userName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget> [
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        'Email : ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        userEmail,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    child: TextField(
                      decoration: textFieldInputDecoration("Enter password to delete Account"),
                      controller: passEditingController,
                    ),
                  ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Delete Account"),
                          content: Text("Are you sure ???"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                AuthService().deleteUser(userEmail, passEditingController.text, context);
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Yes"),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                const Color(0x36FFFFFF),
                                Colors.white,
                                const Color(0x0FFFFFFF),
                                Colors.white
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      height: 45,
                      child: Text(
                        "Delete Account",
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("SignOut"),
                          content: Text("Are you sure ???"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                AuthService().signOut();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => Authenticate()));
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Yes"),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                const Color(0x36FFFFFF),
                                Colors.white,
                                const Color(0x0FFFFFFF),
                                Colors.white
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      height: 45,
                      child: Text(
                        "SignOut",
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Future<void> deleteAccount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();

    Firestore.instance.collection("users").document(user.uid).delete().whenComplete(() =>  Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Authenticate())));
  }
}

