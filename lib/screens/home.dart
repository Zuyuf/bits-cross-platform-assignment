import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

enum ToDoModalType { Add, Edit }

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> toDoList = [];
  List<ToDo> renderToDoList = [];

  final _todoController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = true;

  //

  @override
  void initState() {
    _fetchTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 50,
                                bottom: 20,
                              ),
                              child: const Text(
                                'All ToDos',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (renderToDoList.isNotEmpty)
                              for (ToDo todoo in renderToDoList.reversed)
                                ToDoItem(
                                  todo: todoo,
                                  onToDoChanged: _handleToDoChange,
                                  onDeleteItem: _deleteToDoItem,
                                  onEditItem: _showEditToDoModel,
                                )
                            else
                              const Text(
                                'No ToDos Found!!!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // Expanded(
              //   child: Container(
              //     margin: const EdgeInsets.only(
              //       bottom: 20,
              //       right: 20,
              //       left: 20,
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 20,
              //       vertical: 5,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       boxShadow: const [
              //         BoxShadow(
              //           color: Colors.grey,
              //           offset: Offset(0.0, 0.0),
              //           blurRadius: 10.0,
              //           spreadRadius: 0.0,
              //         ),
              //       ],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: TextField(
              //       controller: _todoController,
              //       decoration: const InputDecoration(
              //           hintText: 'Add a new todo item',
              //           border: InputBorder.none),
              //     ),
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    _showAddTodoModal();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchTodos() async {
    setState(() {
      isLoading = true;
    });

    final result = await ToDo.getTodoList();

    setState(() {
      toDoList = result;
      renderToDoList = result;
      isLoading = false;
    });
  }

  void _showAddTodoModal() {
    _todoController.clear();
    _descriptionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAddEditTodoModal(
          ToDoModalType.Add,
          (closeDialogCB) => _addToDoItem(closeDialogCB),
        );
      },
    );
  }

  void _showEditToDoModel(ToDo todo) async {
    _todoController.text = todo.title;
    _descriptionController.text = todo.description ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAddEditTodoModal(
          ToDoModalType.Edit,
          (closeDialogCB) => _updateToDo(todo, closeDialogCB),
        );
      },
    );
  }

  void _handleToDoChange(ToDo todo) async {
    showModalLoader('Toggling Done Status...');

    var updated = await ToDo.handleTodoChange(todo);

    if (updated) {
      setState(() {
        todo.isDone = !todo.isDone;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("FAILED: To Toggle ToDo isDone Status"),
        behavior: SnackBarBehavior.floating,
      ));
    }

    // Dismiss the dialog
    Navigator.of(context).pop();
  }

  void _deleteToDoItem(String id) async {
    showModalLoader('Deleting...');

    var hasDeleted = await ToDo.deleteTodo(id);

    if (hasDeleted) {
      setState(() {
        renderToDoList.removeWhere((item) => item.id == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("FAILED: To Delete ToDo"),
        behavior: SnackBarBehavior.floating,
      ));
    }

    // Dismiss the dialog
    Navigator.of(context).pop();
  }

  void _updateToDo(ToDo todo, Function closeDialogCB) async {
    String title = _todoController.text;
    String description = _descriptionController.text;

    if (title.trim() == '' || description.trim() == '') return;

    closeDialogCB();
    showModalLoader('Updating ToDo...');

    var updated = await ToDo.updateTodo(todo.id!, title, description);

    if (updated) {
      setState(() {
        todo.title = title;
        todo.description = description;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("FAILED: To Update ToDo"),
        behavior: SnackBarBehavior.floating,
      ));
    }

    // Dismiss the dialog
    Navigator.of(context).pop();
  }

  void _addToDoItem(Function closeDialogCB) async {
    String title = _todoController.text;
    String description = _descriptionController.text;

    if (title.trim() == '' || description.trim() == '') return;

    closeDialogCB();
    showModalLoader('Adding ToDo...');

    ToDo newToDo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timeInEpoch: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description);

    var objectId = await ToDo.addTodo(newToDo);

    if (objectId != null) {
      newToDo.id = objectId;

      setState(() {
        renderToDoList.add(newToDo);
      });
      _todoController.clear();
      _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("FAILED: To Add New ToDo"),
        behavior: SnackBarBehavior.floating,
      ));
    }

    // Dismiss the dialog
    Navigator.of(context).pop();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = toDoList;
    } else {
      results = toDoList
          .where((item) =>
              item.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      renderToDoList = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        const Text(
          '2022MT93750',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
            color: tdBlack,
          ),
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/zuyuf_hacker_.png'),
          ),
        ),
      ]),
    );
  }

  showModalLoader(String loaderLabel) {
    // Show dialog with loader
    showDialog(
      context: context,
      barrierDismissible:
          false, // User cannot dismiss the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(loaderLabel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddEditTodoModal(
      ToDoModalType type, Function(Function) ctaHandler) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            type == ToDoModalType.Add ? 'Add ToDo' : 'Edit ToDo',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoController,
                  decoration: const InputDecoration(
                    hintText: 'Add a new todo item',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  // Add a controller for the description
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Add a description',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    type == ToDoModalType.Add ? 'Add ToDo' : 'Update ToDo',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    ctaHandler(() => Navigator.of(context).pop());

                    // _addToDoItem(
                    //   () => Navigator.of(context).pop(),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: const Size(100, 40),
                    elevation: 10,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
