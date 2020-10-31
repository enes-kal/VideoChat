import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';


class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}



class _VideoCallScreenState extends State<VideoCallScreen> {

RTCVideoViewController _localVideoViewController;
RTCVideoViewController _remoteVideoViewController;



  String sessionId = "TestSessionID";
int userId = 123730736;
int opponentId = 123729719;

Future<void> play(String sessionId,int _opponentId,int _userId ) async {
  
  _localVideoViewController.play(sessionId, userId);
  _remoteVideoViewController.play(sessionId, opponentId);
}

@override
  void initState() {
    initvideo();
    _listenForCall();
    // TODO: implement initState
    super.initState();
  }

  void initvideo()async
  {
    try {
  await QB.webrtc.init();
  
} on PlatformException catch (e) {
  // Some error occured, look at the exception message for more details
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          new Container(
  margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
  width: 160.0,
  height: 160.0,
  child: RTCVideoView(
    onVideoViewCreated: _onLocalVideoViewCreated,
  ),
  decoration: new BoxDecoration(color: Colors.black54),
),
SizedBox(height: 30),
new Container(
  margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
  width: 160.0,
  height: 160.0,
  child: RTCVideoView(
    onVideoViewCreated: _onRemoteVideoViewCreated,
  ),
  decoration: new BoxDecoration(color: Colors.black54),
),
RaisedButton(child:Text('CALL'), onPressed: (){
 startCall();
}),
RaisedButton(child: Text('ACCEPT'),onPressed: (){
_acceptCall();
}),
RaisedButton(child: Text('REJECT'),onPressed: (){
_rejectCall();
}),
RaisedButton(child: Text('LISTEN'),onPressed: (){
_listenForCall();
})
        ],
      ),
    );
  }




void _rejectCall()async
{
  
  try {
  QBRTCSession session = await QB.webrtc.hangUp(sessionId );
} on PlatformException catch (e) {
  // Some error occured, look at the exception message for more details 
}
}




  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    print('INIT LOCAL VIDEO VIEW'+controller.toString());
  _localVideoViewController = controller;
}

void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
  _remoteVideoViewController = controller;
}



 startCall() async{
  List<int> opponentIds = [123729719, 123730736];
  bool connected = await QB.chat.isConnected();
  print('starting call'+connected.toString());
  int sessionType = QBRTCSessionTypes.VIDEO;

  try {
    QBRTCSession session = await QB.webrtc.call(opponentIds, sessionType);
    print('starting call'+session.id);
    sessionId = session.id;
    play(session.id,opponentId,userId);
  } on PlatformException catch (e) {
    print('error while initializing call'+e.toString());
  }
}

 _acceptCall() async{
  try {

    QBRTCSession session = await QB.webrtc.accept(sessionId);
    print('listening call'+session.id+', initiatorid:'+session.initiatorId.toString());
    sessionId = session.id;
    play(sessionId,userId,opponentId);
    setState(() {
  //    _callStarted = true;
    });

  } on PlatformException catch (e) {
    // Some error occured, look at the exception message for more details
  }
}

  _endCall() async{
  try {
    QBRTCSession session = await QB.webrtc.hangUp(sessionId);
    setState(() {
     
    });
  } on PlatformException catch (e) {
    // Some error occured, look at the exception message for more details
  }
}



 _listenForCall() async {
  print('listening for call');
  String eventName = QBRTCEventTypes.CALL;
  try { 
   
    await QB.webrtc.subscribeRTCEvent(eventName, (data) async {
      Map<String, Object> payloadMap = new Map<String, Object>.from(data["payload"]);
      Map<String, Object> sessionMap = new Map<String, Object>.from(payloadMap["session"]);
      String sessionId = sessionMap["id"];
      int initiatorId = sessionMap["initiatorId"];
      int callType = sessionMap["type"];

      setState(() {
        this.sessionId = sessionId;
      //  _incomingCall = true;
      });
     // play(myQBUserId,initiatorId,sessionId);
    });

    await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) async {
      Map<String, Object> payloadMap = new Map<String, Object>.from(data["payload"]);
      Map<String, Object> sessionMap = new Map<String, Object>.from(payloadMap["session"]);
      String sessionId = sessionMap["id"];
      int initiatorId = sessionMap["initiatorId"];
      int callType = sessionMap["type"];

      print('receiving video even from initiator:'+initiatorId.toString());

      this.sessionId = sessionId;
      setState(() {
       // _callStarted = true;
      });

      await QB.webrtc.enableAudio(sessionId, enable: true);

      await QB.webrtc.enableVideo(sessionId, enable: true);

    });

  } on PlatformException catch (e) {
    print('error while listening for calls'+e.toString());
  }
}
}

//	#149248