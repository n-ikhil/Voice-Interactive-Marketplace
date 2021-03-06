import 'package:flutter/material.dart';
import 'package:myna/constants/SharedPreferencesFunctions.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/widgetAndThemes/theme.dart';
import 'package:myna/screens/chat/chat.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final SharedObjects myModel;
  ChatRoom({this.myModel});
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
                  String chatAliasName = snapshot
                      .data.documents[index].data['aliasName']
                      .toString()
                      .replaceAll('|', '')
                      .replaceAll(
                          (widget.myModel.currentUser.nickName != "NA")
                              ? widget.myModel.currentUser.nickName
                              : "",
                          "")
                      .replaceAll(' ', '');
                  if (!chatAliasName.isNotEmpty) {
                    chatAliasName =
                        widget.myModel.currentUser.nickName + "-self";
                  }
                  return ChatRoomsTile(
                    userName: chatAliasName,
                    chatRoomId:
                        snapshot.data.documents[index].data["chatroomid"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    widget.myModel.firestoreClientInstance.chatRoomClient
        .getUserChats(widget.myModel.currentUser.userID)
        .then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${widget.myModel.currentUser.userID}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          APP_NAME,
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Consumer<SharedObjects>(builder: (context, myModel, child) {
                      return Chat(
                        chatRoomId: chatRoomId,
                        myModel: myModel,
                      );
                    })));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(),
            // borderRadius: BorderRadius.circular(20),
            color: Colors.lightGreen[200]),
        // color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CustomColorTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            SizedBox(
                width: 200,
                child: Text(
                  userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300,
                  ),
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }
}
