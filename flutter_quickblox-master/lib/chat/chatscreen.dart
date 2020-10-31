import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_app/video/videocallscreen.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class ChatScreen extends StatefulWidget {
  String dialogID;
  ChatScreen(this.dialogID);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
   
    // TODO: implement initState
    super.initState();
  }

  void initVideoRTC()async{
     try {
  await QB.webrtc.init();
} on PlatformException catch (e) {
  // Some error occured, look at the exception message for more details
}

  }


   final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      backgroundColor: Colors.blue,

      body: Column(
        
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          topBar(),
          Expanded(
              child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[100],
            ),
          ),
         bottombar()
        ],
      )
      );
  }

  _sendChat() async {
    try {
      await QB.chat.sendMessage(widget.dialogID, body: myController.text, markable: false, saveToHistory: true);
    } catch (e) {
      print("send caht");
      print(e.toString());
    }
  }

  _getHistory() async {
    try {
      List<QBMessage> messages = await QB.chat.getDialogMessages(widget.dialogID, markAsRead: true);

      // print(messages.first.id);
    } catch (e) {
      print("gethistory");
      print(e.toString());
      // Some error occured, look at the exception message for more details
    }
  }

  Widget bottombar()
  {
      return  Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Container(
              height: 60,
              padding: EdgeInsets.all(5),
              color: Colors.grey[300],
              child: Row( children: <Widget>[
                Expanded(
                  child: TextFormField(
                   controller: myController,

                    ),
                  ),
                  SizedBox(width: 5),
                  ButtonTheme(
                    height: 60,
                    shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12)),
                    child: RaisedButton.icon(
                    color: Colors.blue,
                    label: Text(''),
                    shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)
                    ),
                    icon: Icon(Icons.send, color: Colors.white,),
                    
                    onPressed: () {
                    //    ChatService().sendMessage('Hello',widget.member);
                     //   ChatService().sendMessage(myController.text,widget.member);
                    _sendChat();
                    myController.clear();
                    },
                  ),
                  )
                ],
              ),
            ),
      );
  }

  Widget topBar()
  {
    return Container(
      color: Colors.grey[300],
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.call) , onPressed:() {

          }),
           IconButton(icon: Icon(Icons.video_call) , onPressed:() {
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => VideoCallScreen()),
  );
          })
        ],
      ) 
      
      
      );
  }
}