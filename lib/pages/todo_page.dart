import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widget/dialogs.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController todoController;
  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade300,
              Colors.red.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'Create a new TODO',
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                              content: TextField(
                                controller: todoController,
                                decoration: InputDecoration(
                                  hintText: 'Pls Enter TODO',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Cancle',
                                    style:
                                        TextStyle(color: Colors.red.shade800),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text(
                                    'Save',
                                    style:
                                        TextStyle(color: Colors.red.shade800),
                                  ),
                                  onPressed: () async {
                                    if (todoController.text.isEmpty) {
                                      showSnackBar(
                                          context, 'Pls Enter a Todo First');
                                    } else {
                                      String username = await context
                                          .read<UserService>()
                                          .currentUser
                                          .username;
                                      Todo todo = Todo(
                                        username: username,
                                        title: todoController.text.trim(),
                                        created: DateTime.now(),
                                      );
                                      if (context
                                          .read<TodoService>()
                                          .todos
                                          .contains(todo)) {
                                        showSnackBar(context,
                                            'Dublicate value pls try again');
                                      } else {
                                        String result = await context
                                            .read<TodoService>()
                                            .createTodo(todo);
                                        if (result == 'OK') {
                                          showSnackBar(context,
                                              'New Todo successfully Add');
                                          todoController.text = '';
                                        } else {
                                          showSnackBar(context, result);
                                        }
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) {
                    return Text(
                      '${value.name}\'s Todo List ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<TodoService>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.todos.length,
                        itemBuilder: (context, index) {
                          return TodoCard(
                            todo: value.todos[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.red.shade100,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red.shade700,
            icon: Icons.delete,
            onTap: () async {
              String result =
                  await context.read<TodoService>().deleteTodo(todo);
              if (result == 'OK') {
                showSnackBar(context, 'Successfuly Deleted');
              } else {
                showSnackBar(context, result);
              }
            },
          ),
        ],
        child: CheckboxListTile(
          value: todo.done,
          checkColor: Colors.red,
          activeColor: Colors.white,
          subtitle: Text(
            '${todo.created.day}/${todo.created.month}/${todo.created.year}',
            style: TextStyle(
              color: Colors.red.shade900,
              decoration: TextDecoration.none,
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              color: Colors.red.shade900,
              decoration:
                  todo.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          onChanged: (value) async {
            String result =
                await context.read<TodoService>().toggleTodoDone(todo);
            if (result != 'OK') {
              showSnackBar(context, result);
            }
          },
        ),
      ),
    );
  }
}
