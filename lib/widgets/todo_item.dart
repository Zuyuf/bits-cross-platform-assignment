// import 'package:flutter/material.dart';

// import '../model/todo.dart';
// import '../constants/colors.dart';

// class ToDoItem extends StatelessWidget {
//   final ToDo todo;
//   final onToDoChanged;
//   final onDeleteItem;

//   const ToDoItem({
//     Key? key,
//     required this.todo,
//     required this.onToDoChanged,
//     required this.onDeleteItem,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       child: ListTile(
//         onTap: () {
//           // print('Clicked on Todo Item.');
//           onToDoChanged(todo);
//         },
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//         tileColor: Colors.white,
//         leading: Icon(
//           todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
//           color: tdBlue,
//         ),
//         title: Text(
//           todo.title!,
//           style: TextStyle(
//             fontSize: 16,
//             color: tdBlack,
//             decoration: todo.isDone ? TextDecoration.lineThrough : null,
//           ),
//         ),
//         trailing: Container(
//           padding: EdgeInsets.all(0),
//           margin: EdgeInsets.symmetric(vertical: 12),
//           height: 35,
//           width: 35,
//           decoration: BoxDecoration(
//             color: tdRed,
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: IconButton(
//             color: Colors.white,
//             iconSize: 18,
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               // print('Clicked on delete icon');
//               onDeleteItem(todo.id);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// ===========================######################################===================================

// import 'package:flutter/material.dart';

// import '../model/todo.dart';
// import '../constants/colors.dart';

// class ToDoItem extends StatelessWidget {
//   final ToDo todo;
//   final Function(ToDo) onToDoChanged;
//   final Function(String) onDeleteItem;

//   const ToDoItem({
//     Key? key,
//     required this.todo,
//     required this.onToDoChanged,
//     required this.onDeleteItem,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: ListTile(
//         onTap: () {
//           onToDoChanged(todo);
//         },
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//         tileColor: Colors.white,
//         leading: Icon(
//           todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
//           color: tdBlue,
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               todo.title!,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: tdBlack,
//                 decoration: todo.isDone ? TextDecoration.lineThrough : null,
//               ),
//             ),
//             if (todo.description != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: Text(
//                   todo.description!,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: tdGrey,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         trailing: Container(
//           padding: EdgeInsets.all(0),
//           margin: EdgeInsets.symmetric(vertical: 12),
//           height: 35,
//           width: 35,
//           decoration: BoxDecoration(
//             color: tdRed,
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: IconButton(
//             color: Colors.white,
//             iconSize: 18,
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               onDeleteItem(todo.id!);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;
  final Function(ToDo) onEditItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title!,
              style: TextStyle(
                fontSize: 16,
                color: tdBlack,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            if (todo.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  todo.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: tdGrey,
                  ),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 12),
              height: 50,
              width: 40,
              decoration: BoxDecoration(
                color: tdBlue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onEditItem(todo);
                },
              ),
            ),
            SizedBox(width: 5),
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 12),
              height: 50,
              width: 40,
              decoration: BoxDecoration(
                color: tdRed,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDeleteItem(todo.id!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
