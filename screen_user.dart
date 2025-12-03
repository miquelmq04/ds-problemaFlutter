import 'package:flutter/material.dart';
import 'package:problema/screen_list_users.dart';

import 'data.dart';
import 'package:problema/InputDecorationTextFormField.dart';

class ScreenUser extends StatefulWidget {
  late UserGroup userGroup;

  ScreenUser({super.key,required this.userGroup});

  @override
  State<ScreenUser> createState() => _ScreenUserState();
}

class _ScreenUserState extends State<ScreenUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _credentialController = TextEditingController();
  late UserGroup userGroup;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
  }
  @override
  void dispose() {
    _nameController.dispose();
    _credentialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("User"),
      ),
      body: Form(
        child: Container(
          margin: EdgeInsetsGeometry.fromLTRB(30,100,30,0),
          child: Column(
            spacing: 40,
            children: [
              CircleAvatar(
                radius: 85,
                backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(Data.images['new user']!),
                  radius: 75,
                ),
              ),
              InputDecorationTextFormField(name: 'name', exampleInput: 'new user',controller : _nameController),
              InputDecorationTextFormField(name: 'credential', exampleInput: '00000', controller : _credentialController),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(0,30,0,0),
                child: ElevatedButton(onPressed: () {
                  String name = _nameController.text;
                  String credential = _credentialController.text;
                  User newUser = User(name,credential);
                  userGroup.users.add(newUser);
                  ScaffoldMessenger.of(context) .showSnackBar( const SnackBar(content: Text('User created')));
                  }, child: Text("Submit")),
              )
            ],
          ),
        ),
      )
    );
  }
}
