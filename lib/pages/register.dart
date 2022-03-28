import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/routes/routes.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widget/app_textfield.dart';
import 'package:todo_app/widget/dialogs.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernameController;
  late TextEditingController nameController;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Register User',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  Focus(
                    onFocusChange: (value) async {
                      if (!value) {
                        String result = await context
                            .read<UserService>()
                            .checkIfUserExist(usernameController.text.trim());
                        if (result == 'ok') {
                          context.read<UserService>().userExist = true;
                        } else {
                          context.read<UserService>().userExist = false;
                          if (result.contains(
                              'The user does not exist in the database. Please register first.')) {
                            showSnackBar(context, result);
                          }
                        }
                      }
                    },
                    child: AppTextField(
                      labelText: 'Pls Enter Your Username',
                      controller: usernameController,
                    ),
                  ),
                  Selector<UserService, bool>(
                    selector: (context, value) => value.userExist,
                    builder: (context, value, child) {
                      return value
                          ? const Text(
                              'Username Already Taken',
                              style: TextStyle(color: Colors.white),
                            )
                          : Container();
                    },
                  ),
                  AppTextField(
                    labelText: 'Pls Enter Your Name',
                    controller: nameController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade800,
                      ),
                      child: Text('Register'),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (usernameController.text.isEmpty ||
                            nameController.text.isEmpty) {
                          showSnackBar(context, 'Pls Enter All Fields!');
                        } else {
                          User user = User(
                            username: usernameController.text.trim(),
                            name: nameController.text.trim(),
                          );
                          String result = await context
                              .read<UserService>()
                              .createUser(user);
                          if (result != 'OK') {
                            showSnackBar(context, result);
                          } else {
                            showSnackBar(
                                context, 'New User Successfully Created');
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 30,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Selector<UserService, bool>(
            selector: (context, value) => value.busyCreate,
            builder: (context, value, child) {
              return value ? const AppProgressIndicator() : Container();
            },
          )
        ],
      ),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 20,
          width: 20,
          child: const CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
