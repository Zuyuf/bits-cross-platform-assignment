import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo_b4a.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

final keyApplicationId = 'gcAgJdBU02WLIUDWN8dHquZwbgjiwhNQFg04IPK0';
final keyClientKey = '5bPBrX4DPH8CTruxydMQm83ROERKWkUG8bybw2w6';
final keyParseServerUrl = 'https://parseapi.back4app.com';

class ToDo {
  String? id;
  String title;
  String? description;
  String? timeInEpoch;
  bool isDone;

  ToDo({
    required this.title,
    this.description,
    this.timeInEpoch,
    this.id,
    this.isDone = false,
  }) {
    // initData();
  }

  // Future<void> initData() async {
  //   String text = 'B4A  -  ';
  //   // Initialize parse
  //   await Parse().initialize(keyApplicationId, keyParseServerUrl,
  //       clientKey: keyClientKey, debug: true);
  // }

  static Future<List<ToDo>> getTodoList() async {
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, debug: true);

    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('ToDo'));

    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return ToDo.convertToToDoList(apiResponse.results! as List<ParseObject>);
    } else {
      return [];
    }
  }

  static Future<String?> addTodo(ToDo todo) async {
    final parseObj = ParseObject('ToDo')
      ..set('title', todo.title)
      ..set('description', todo.description)
      ..set('timeInEpoch', todo.timeInEpoch)
      ..set('done', todo.isDone);

    var response = await parseObj.save();

    if (response.success) {
      return parseObj.objectId!;
    }

    return null;
  }

  static Future<bool> updateTodo(
    String objectId,
    String title,
    String description,
  ) async {
    var parseObj = ParseObject('ToDo')
      ..objectId = objectId
      ..set('title', title)
      ..set('description', description);

    var response = await parseObj.save();

    return response.success;
  }

  static Future<bool> handleTodoChange(ToDo _todo) async {
    var parseObj = ParseObject('ToDo')
      ..objectId = _todo.id
      ..set('done', !_todo.isDone);

    var response = await parseObj.save();

    return response.success;
  }

  static Future<bool> deleteTodo(String objectId) async {
    var todo = ParseObject('ToDo')..objectId = objectId;
    var response = await todo.delete();

    return response.success;
  }

  static List<ToDo> convertToToDoList(List<ParseObject> todoB4AList) {
    return todoB4AList.map((parseObject) {
      if (parseObject.runtimeType == ParseObject) {
        return ToDo(
          id: parseObject.objectId,
          title: parseObject.get<String>('title')!,
          description: parseObject.get<String>('description') ?? '',
          timeInEpoch: parseObject.get<String>('timeInEpoch')!,
          isDone: parseObject.get<bool>('done')!,
        );
      } else {
        // Handle other types of ParseObjects if needed
        throw Exception("Unexpected object type in the list");
      }
    }).toList();
  }

  //
}
