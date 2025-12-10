import 'package:flutter/material.dart';

import 'data.dart';
import 'screen_user.dart';

class CheckBoxItem extends StatelessWidget {
  final String actionName;
  final String actionDesc;
  bool checked;
  final Function(String) onChecked;
  final String actionCode;

  CheckBoxItem({super.key,required this.actionName,
    required this.actionDesc, required this.checked,
    required this.onChecked, required this.actionCode});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        this.actionName,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        this.actionDesc,
        style: TextStyle(fontSize: 14),
      ),
      value: checked,
      onChanged: (bool? newValue) {
        checked = newValue!;
        onChecked.call(this.actionCode);
      },
    );
  }
}

class ScreenActionsGroup extends StatefulWidget {
  UserGroup userGroup;
  late List<String> markedActions;


  ScreenActionsGroup({super.key, required this.userGroup}) {
    markedActions = [...userGroup.actions];
  }

  @override
  State<ScreenActionsGroup> createState() => _ScreenActionsGroupState();
}

class _ScreenActionsGroupState extends State<ScreenActionsGroup> {
  late UserGroup userGroup;
  late List<String> markedActions;

  @override
  void initState() {
    super.initState();
    markedActions = widget.markedActions;
    userGroup = widget.userGroup;
  }

  void _onChecked(String action) {
    setState(() {
      if (markedActions.contains(action)) {
        markedActions.remove(action);
      }
      else {
        markedActions.add(action);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text("Actions for ${userGroup!.name}"),
        ),
        body: Column(
          children: <Widget>[
            CheckBoxItem(actionName: 'Open', actionDesc: 'Opens an unlocked door',
              checked: markedActions.contains('open'),onChecked: _onChecked,
              actionCode: 'open',),
            Divider(),
            CheckBoxItem(actionName: 'Close', actionDesc: 'Closes an open door',
              checked: markedActions.contains('close'),onChecked: _onChecked,
              actionCode: 'close',),
            Divider(),
            CheckBoxItem(actionName: 'Lock', actionDesc: 'Locks a door or all the doors in a rooom or group of rooms, if closed',
              checked: markedActions.contains('lock'),onChecked: _onChecked,
              actionCode: 'lock',),
            Divider(),
            CheckBoxItem(actionName: 'Unlock', actionDesc: 'Unlocks a locked door or all the locked doors in a room',
              checked: markedActions.contains('unlock'),onChecked: _onChecked,
              actionCode: 'unlock',),
            Divider(),
            CheckBoxItem(actionName: 'Unlock Shortly', actionDesc: 'Unlocks a door during 10 seconds and then locks it if it is closed',
              checked: markedActions.contains('unlock_shortly'),onChecked: _onChecked,
              actionCode: 'unlock_shortly',),
            Divider(),
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(0,30,0,0),
              child: ElevatedButton(onPressed: () {
                userGroup.actions = markedActions;
                ScaffoldMessenger.of(context) .showSnackBar( const SnackBar(content: Text('Saved')));
              }, child: Text("Submit")),
            )

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
