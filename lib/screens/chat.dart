import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_globe/helper/constants.dart';
import 'package:connect_globe/services/database.dart';
import 'package:connect_globe/widget/widget.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  File imageFile;
  bool isLoading;
  String imageUrl;
  bool isWriting = false;
  bool showEmojiPicker = false;

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  FocusNode textFieldFocus = FocusNode();


  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
                return (snapshot.data.documents[index].data["message"] == "Img") ?
                Container(
                  padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: (Constants.myName == snapshot.data.documents[index].data["sendBy"]) ? 0 : 24,
                      right: (Constants.myName == snapshot.data.documents[index].data["sendBy"]) ? 24 : 0),
                  alignment: (Constants.myName == snapshot.data.documents[index].data["sendBy"]) ? Alignment.centerRight : Alignment.centerLeft,
                  child: Image.network(
                      snapshot.data.documents[index].data["url"].toString(),
                      cacheHeight: 220,
                      cacheWidth: 220,
                  ),
                  )
                  : MessageTile(
                  message: snapshot.data.documents[index].data["message"],
                  sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
                );
            }) : Container();
      },
    );
  }


  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        'url': "No Img"
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }


  addImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child("${widget.chatRoomId}/${fileName}");
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        if (imageUrl.isNotEmpty) {
          Map<String, dynamic> imgUrl = {
            "sendBy": Constants.myName,
            "message": "Img",
            'time': DateTime
                .now()
                .millisecondsSinceEpoch,
            'url': imageUrl
          };

          DatabaseMethods().addImage(widget.chatRoomId, imgUrl);
        }
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
    });
  }


  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.brown,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if (!showEmojiPicker) {
                          // keyboard is visible
                          hideKeyboard();
                          showEmojiContainer();
                        } else {
                          //keyboard is hidden
                          showKeyboard();
                          hideEmojiContainer();
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        child: Icon(
                          Icons.insert_emoticon,
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        margin: EdgeInsets.all(5),
                      ),
                    ),
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          focusNode: textFieldFocus,
                          onTap: () => hideEmojiContainer(),
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: (){
                        addImage();
                      },
                      child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/img.png",
                            height: 50, width: 50,)),
                      ),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),

                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 85),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: showEmojiPicker ? Container(child: emojiContainer()) : Container(height: 0, width: 0,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Color(0xff272c35),
      indicatorColor: Color(0xff2b9ed4),
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        messageEditingController.text = messageEditingController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 20,
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
