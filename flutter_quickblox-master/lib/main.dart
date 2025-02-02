import 'package:flutter/material.dart';
import 'package:quickblox_app/login/login.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String APP_ID = "86893";
  const String AUTH_KEY = "DrNR-chXcj7t4uS";
  const String AUTH_SECRET = "PRgWGYUHhZp4VTa";
  const String ACCOUNT_KEY = "2Qdse-kz_QKdgej_vhLo";
  const String API_ENDPOINT = ""; //optional
  const String CHAT_ENDPOINT = ""; //optional

  try {
    await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY, apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);
  } catch (e) {
    print(e.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
