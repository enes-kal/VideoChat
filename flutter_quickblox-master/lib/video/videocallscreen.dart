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

Future<void> play(String sessionId ) async {
  
  _localVideoViewController.play(sessionId, userId);
  _remoteVideoViewController.play(sessionId, opponentId);
}

@override
  void initState() {
    initvideo();
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
  getcurrentsession();

  play(sessionId);
}),
RaisedButton(child: Text('ACCEPT'),onPressed: (){
_acceptCall();
})
        ],
      ),
    );
  }


     _acceptCall() async{
  try {

    QBRTCSession session = await QB.webrtc.accept(sessionId);
    print('listening call'+session.id+', initiatorid:'+session.initiatorId.toString());
    sessionId = session.id;
    play(sessionId);
    setState(() {
    //  _callStarted = true;
    });

  } on PlatformException catch (e) {
    // Some error occured, look at the exception message for more details
  }
}



  Future<void> getcurrentsession()async {
    initvideo();
    List<int> opponentIds = [123729719, 123730736];
    int sessionType = QBRTCSessionTypes.VIDEO;
    try {
      
     QBRTCSession sessionx = await QB.webrtc.call(opponentIds, sessionType);
    //  sessionx.id; 
 // QBSession session = await QB.auth.getSession();
 sessionId=sessionx.id;
  print(sessionx.id);
} on PlatformException catch (e) {
  // Some error occured, look at the exception message for more details
  print(e);
}
  }

  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
  _localVideoViewController = controller;
}

void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
  _remoteVideoViewController = controller;
}
}

//	#149248