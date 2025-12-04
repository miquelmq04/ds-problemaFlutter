import 'package:flutter/material.dart';

import 'data.dart';
import 'the_drawer.dart';
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
                  ScreenUser(userGroup : userGroup)))
              .then((var v) => setState(() {}));
        },
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("Users ${userGroup!.name}"),
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
    final imagePath = Data.images[user.name.toLowerCase()];
    final imageDefault = Data.images['new user'];
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: imagePath != null ? AssetImage(imagePath) : AssetImage(imageDefault!),
          radius: 20,
        ),
      title: Text(user.name),
      trailing: Text(user.credential),
      onTap: () {},
    );
  }
}
