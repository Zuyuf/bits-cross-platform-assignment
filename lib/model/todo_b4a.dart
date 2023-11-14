import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ToDoB4A extends ParseObject {
  late String todoText;
  late String timeInEpoch;
  late bool done;

  ToDoB4A(super.className);
}
