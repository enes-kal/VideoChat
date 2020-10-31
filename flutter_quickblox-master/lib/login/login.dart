import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_app/home/home.dart';
import 'package:quickblox_app/users.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<Users> users = [
    Users(login: "enes", password: "12345678"),
    Users(login: "ahmet", password: "12345678"),
  ];
  void _loginToQuickBlox(String login, String password) async {
    QBUser qbUser;
    QBSession qbSession;
    try {
      QBLoginResult result = await QB.auth.login(login, password);
      qbUser = result.qbUser;
      qbSession = result.qbSession;
      print(qbSession.tokenExpirationDate);
      print(qbUser.fullName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    qbSession: qbSession,
                    qbUser: qbUser,
                  )));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(child: Text('Enes'), onPressed: (){
              _loginToQuickBlox(users[0].login, users[0].password);
            }),
             RaisedButton(child: Text('Ahmet'), onPressed: (){
              _loginToQuickBlox(users[1].login, users[1].password);
            }),
             RaisedButton(child: Text('Register'), onPressed: (){
             registerToQuick();
            })
          ],
        ),
      )
          
    );
  }

  void registerToQuick()async
  {

  try {
    
  QBUser user = await QB.users.createUser(
      'mehmet1', 
      'password123', 
     );
} on PlatformException catch (e) {
  // Some error occured, look at the exception message for more details
}

  }
}
