import 'package:flutter/material.dart';
import 'dart:io';
import 'data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gestio_usuaris/InputDecorationTextFormField.dart';

class ScreenUser extends StatefulWidget {
  late UserGroup userGroup;
  late User? user;

  ScreenUser({super.key,required this.userGroup, required this.user});

  @override
  State<ScreenUser> createState() => _ScreenUserState();
}

class _ScreenUserState extends State<ScreenUser> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _credentialController = TextEditingController();

  late UserGroup userGroup;
  late User? user;

  late bool isNewUser;

  String? imagePath;
  ImageProvider? avatarProvider;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    user = widget.user;
    isNewUser = (widget.user == null);

    _loadInitialImage();
  }
  @override
  void dispose() {
    _nameController.dispose();
    _credentialController.dispose();
    super.dispose();
  }

  void _loadInitialImage() {
    final key = isNewUser ? 'new user' : user!.name.toLowerCase();
    imagePath = Data.images[key] ?? 'faces/new_user.png';
    avatarProvider = _getImageProvider(imagePath!);
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.startsWith('faces/')) return AssetImage(path);
    if (File(path).existsSync()) return FileImage(File(path));
    return const AssetImage('faces/new_user.png');
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      imagePath = result.files.single.path!;
      avatarProvider = FileImage(File(imagePath!));
    });
  }

  void _saveUserImage(String name) {
    if (imagePath == null || imagePath == Data.images['new user']) return;

    final userImageKey = name.toLowerCase();
    Data.images[userImageKey] = imagePath!;
  }

  void _createNewUser(String name, String credential) {
    _saveUserImage(name);

    final newUser = User(name, credential);
    userGroup.users.add(newUser);

    _showSnackBar('User created');
    Navigator.pop(context, newUser);
  }

  void _updateExistingUser(String name, String credential) {
    final oldName = user!.name.toLowerCase();

    user!.name = name;
    user!.credential = credential;

    if (imagePath != null) {
      final newImageKey = name.toLowerCase();
      Data.images[newImageKey] = imagePath!;

      // Eliminar entrada antigua si cambió el nombre
      if (oldName != newImageKey && Data.images.containsKey(oldName)) {
        Data.images.remove(oldName);
      }
    }

    _showSnackBar('User info updated');
    Navigator.pop(context, user);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text;
    final credential = _credentialController.text;

    if (isNewUser) {
      _createNewUser(name, credential);
    } else {
      _updateExistingUser(name, credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(isNewUser ? "New User" : "User Info" ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsetsGeometry.fromLTRB(30,50,30,0),
            child: Column(
              spacing: 30,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                    child: CircleAvatar(
                      backgroundImage: avatarProvider,
                      radius: 75,
                    ),
                  ),
                ),
                InputDecorationTextFormField(name: 'name', exampleInput: 'user',
                  controller : _nameController,
                  initialValue: isNewUser ? '' : user!.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'PLease enter a name';
                    }

                    return null;
                  },
                ),
                InputDecorationTextFormField(name: 'credential', exampleInput: '00000',
                  controller : _credentialController,
                  initialValue: isNewUser ? '' : user!.credential,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'PLease enter a credential';
                    }
                    if(value.length < 5 || value.length > 5){
                      return 'Credential must be 5 characters long';
                    }
                    return null;
                  }
                ),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0,20,0,0),
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
