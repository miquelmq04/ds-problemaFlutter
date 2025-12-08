import 'dart:io';
import 'package:flutter/material.dart';
import 'data.dart';
import 'screen_user.dart';

class ScreenListUsers extends StatefulWidget {
  UserGroup userGroup;

  ScreenListUsers({super.key, required this.userGroup});

  @override
  State<ScreenListUsers> createState() => _ScreenListUsersState();
}

class _ScreenListUsersState extends State<ScreenListUsers> {
  late UserGroup userGroup;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) =>
                  ScreenUser(userGroup : userGroup, user: null,)))
              .then((var v) => setState(() {}));
        },
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("Users ${userGroup.name}"),
      ),
      body: ListView.separated(
        // it's like ListView.builder() but better
        // because it includes a separator between items
        padding: const EdgeInsets.all(16.0),
        itemCount: userGroup.users.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildRow(userGroup.users[index], index),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _buildRow(User user, int index) {
    ImageProvider getImageProvider() {

      // Busca si es una key de Data.images
      final key = user.name.toLowerCase();
      if (Data.images.containsKey(key)) {
        String imagePath = Data.images[key]!;

        // Verificar el tipo de ruta
        if (imagePath.startsWith('http')) {
          return NetworkImage(imagePath);
        } else if (imagePath.startsWith('faces/')) {
          return AssetImage(imagePath);
        } else if (File(imagePath).existsSync()) { // Ruta de archivo local
          return FileImage(File(imagePath));
        }
      }
      return const AssetImage('faces/new_user.png');
    }

    return ListTile(
      leading: CircleAvatar(
        foregroundImage: getImageProvider(),
      ),
      title: Text(user.name),
      trailing: Text(user.credential),
      onTap: () {
        Navigator.push(context, MaterialPageRoute<void>(
            builder: (context) =>
                ScreenUser(userGroup: userGroup, user: userGroup.users[index],)))
            .then((var v) => setState(() {}));
      },
    );
  }
}
