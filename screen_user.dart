import 'package:flutter/material.dart';
import 'data.dart';
import 'package:gestio_usuaris/InputDecorationTextFormField.dart';

class ScreenUser extends StatefulWidget {
  late UserGroup userGroup;

  ScreenUser({super.key,required this.userGroup});

  @override
  State<ScreenUser> createState() => _ScreenUserState();
}

class _ScreenUserState extends State<ScreenUser> {
  final _formKey = GlobalKey<FormState>();
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
          key: _formKey,
          child: Container(
            margin: EdgeInsetsGeometry.fromLTRB(30,50,30,0),
            child: Column(
              spacing: 30,
              children: [
                CircleAvatar(
                  radius: 85,
                  backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(Data.images['new user']!),
                    radius: 75,
                  ),
                ),
                InputDecorationTextFormField(name: 'name', exampleInput: 'new user',controller : _nameController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'PLease enter a name';
                  }

                  return null;
                },

                ),
                InputDecorationTextFormField(name: 'credential', exampleInput: '00000', controller : _credentialController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'PLease enter a credential';
                  }
                  if(value.length < 5 || value.length > 5){
                    return 'Credential must be 5 characters long';
                  }
                  return null;
                }),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0,20,0,0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          String credential = _credentialController.text;
                          User newUser = User(name, credential);
                          userGroup.users.add(newUser);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User created')));
                          Navigator.pop(context, newUser);
                        }
                      },
                  child: Text("Submit")),
                )
              ],
            ),
          ),
        )
    );
  }
}
