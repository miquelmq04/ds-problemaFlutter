import 'package:flutter/material.dart';

import 'data.dart';
import 'screen_user.dart';

class CheckBoxItem extends StatelessWidget {
  late String actionName;
  late String actionDesc;
  late bool checked;

  CheckBoxItem({super.key,required this.actionName,
    required this.actionDesc, required this.checked});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(this.actionName),
      subtitle: Text(this.actionDesc),
      value: this.checked,
      onChanged: null,
    );
  }
}

class ScreenActionsGroup extends StatefulWidget {
  UserGroup userGroup;

  ScreenActionsGroup({super.key, required this.userGroup});

  @override
  State<ScreenActionsGroup> createState() => _ScreenActionsGroupState();
}

class _ScreenActionsGroupState extends State<ScreenActionsGroup> {
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
        title: Text("Actions for ${userGroup!.name}"),
      ),
      body: Column(
        children: <Widget>[
          CheckBoxItem(actionName: 'Open', actionDesc: 'Opens an unlocked door',
              checked: userGroup.actions.contains('open')),
          Divider(),
          CheckBoxItem(actionName: 'Close', actionDesc: 'Closes an open door',
              checked: userGroup.actions.contains('close')),
          Divider(),
          CheckBoxItem(actionName: 'Lock', actionDesc: 'Locks a door or all the doors in a rooom or group of rooms, if closed',
              checked: userGroup.actions.contains('lock')),
          Divider(),
          CheckBoxItem(actionName: 'Unlock', actionDesc: 'Unlocks a locked door or all the locked doors in a room',
              checked: userGroup.actions.contains('unlock')),
          Divider(),
          CheckBoxItem(actionName: 'Unlock Shortly', actionDesc: 'Unlocks a door during 10 seconds and then locks it if it is closed',
              checked: userGroup.actions.contains('unlock_shortly')),
          Divider(),
        ],
      )
    );
  }

  Widget _buildRow(User user, int index) {
    return ListTile(
      title: Text(user.name),
      trailing: Text('${user.credential}'),
      onTap: () {},
    );
  }
}
