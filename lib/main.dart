import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/home.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

final keyApplicationId = 'gcAgJdBU02WLIUDWN8dHquZwbgjiwhNQFg04IPK0';
final keyClientKey = '5bPBrX4DPH8CTruxydMQm83ROERKWkUG8bybw2w6';
final keyParseServerUrl = 'https://parseapi.back4app.com';

void main() async {
  runApp(const MyApp());

  // WidgetsFlutterBinding.ensureInitialized();

  // await Parse().initialize(keyApplicationId, keyParseServerUrl,
  //     clientKey: keyClientKey, autoSendSessionId: true);

  // var firstObject = ParseObject('FirstClass')
  //   ..set(
  //       'message', 'Hey ! First message from Flutter. Parse is now connected');
  // await firstObject.save();

  // print('B4A-done');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: Home(),
    );
  }

  Future<void> initData() async {
    String text = 'B4A  -  ';
    // Initialize repository
    // await initRepository();

    // Initialize parse
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, debug: true);

    //parse serve with secure store and desktop support
    //    Parse().initialize(keyParseApplicationId, keyParseServerUrl,
    //        clientKey: keyParseClientKey,
    //        debug: true);

    // Check server is healthy and live - Debug is on in this instance so check logs for result
    final ParseResponse response = await Parse().healthCheck();

    // var firstObject = ParseObject('FirstClass')
    //   ..set('message',
    //       'Hey ! First message from Flutter. Parse is now connected');
    // await firstObject.save();

    if (response.success) {
      // await runTestQueries();
      text += 'Server health check SUCCESS\n';
      print(text);
    } else {
      text += 'Server health check FAILED';
      print(text);
    }
  }
}
