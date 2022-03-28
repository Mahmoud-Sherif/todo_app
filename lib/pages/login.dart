import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:todo_app/routes/routes.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widget/app_textfield.dart';
import 'package:todo_app/widget/dialogs.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.red.shade300,
              Colors.red.shade900,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Weclome',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                AppTextField(
                  controller: usernameController,
                  labelText: 'Plas Enter Username',
                ),
                ElevatedButton(
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade800,
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (usernameController.text.isEmpty) {
                      showSnackBar(context, 'Pls Enter USername First');
                    } else {
                      String result = await context
                          .read<UserService>()
                          .getUser(usernameController.text.trim());
                      if (result != 'OK') {
                        showSnackBar(context, result);
                      } else {
                        String username =
                            context.read<UserService>().currentUser.username;
                        context.read<TodoService>().getTodods(username);
                        Navigator.of(context).pushNamed(RouteManager.todoPage);
                      }
                    }
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.red.shade100,
                  ),
                  child: const Text('Register a new User'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
