import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_globe/helper/authenticate.dart';
import 'package:connect_globe/helper/constants.dart';
import 'package:connect_globe/helper/helperfunctions.dart';
import 'package:connect_globe/screens/chat.dart';
import 'package:connect_globe/screens/search.dart';
import 'package:connect_globe/screens/setting.dart';
import 'package:connect_globe/services/auth.dart';
import 'package:connect_globe/services/database.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            })
            : Container();
      },
    );
  }

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'LogOut', icon: Icons.exit_to_app),
  ];


  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'LogOut') {
      AuthService().signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Authenticate()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatSettings()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect Globe",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),),
        elevation: 5.0,
        centerTitle: false,
        actions: [
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: Colors.black,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final bool isSelected = false;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
            )
        ));
      },
      onLongPress: (){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Delete"),
            content: Text("Are you sure ???"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Firestore.instance.collection("chatRoom").document(chatRoomId).delete();
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
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.lightGreen[800],
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: Text(userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(userName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.lightBlue[50],
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.white54,
              )
            ],
          ),
        ),
        ),
      );
  }

}

class Choice{
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}