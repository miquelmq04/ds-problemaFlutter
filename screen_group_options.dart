import 'package:flutter/material.dart';
import 'package:problema/screen_list_users.dart';

import 'data.dart';
import 'screen_actions_group.dart';
import 'screen_info_group.dart';
import 'screen_schedule_group.dart';


class GroupOptionWidget extends StatelessWidget {
  late String title;
  late IconData icon ;
  final Widget? page;
  final VoidCallback? onReturn;

  GroupOptionWidget({super.key,required this.title, required this.icon, required this.page,
  required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectOption(context);
      },
      child : Container(
      padding: const EdgeInsets.all(8),
      color: Color.fromRGBO(80, 95, 110,1),
      alignment: Alignment.center,
      child : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(this.icon,
          color: Colors.white,
          size: 100,),Text(this.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
            ))],
      ),
    )
    );
  }

  void selectOption(BuildContext context) {
    if (this.page == null)
      return;
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => this.page!)).then((_) {
      onReturn?.call();
    });
  }
}

class ScreenGroupOptions extends StatefulWidget {
  UserGroup userGroup;

  ScreenGroupOptions({super.key, required this.userGroup});

  @override
  State<ScreenGroupOptions> createState() => _ScreenGroupOptionsState();
}

class _ScreenGroupOptionsState extends State<ScreenGroupOptions> {
  late UserGroup userGroup;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
  }

  void _onReturnFromPage() {
    if (!mounted) return;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("Group ${userGroup!.name}"),
      ),
      body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              GroupOptionWidget(title: 'Info', icon: Icons.description, page: ScreenInfoGroup(userGroup: userGroup),onReturn: _onReturnFromPage,),
              GroupOptionWidget(title: 'Schedule', icon: Icons.calendar_month, page: ScreenScheduleGroup(userGroup: userGroup),onReturn: _onReturnFromPage),
              GroupOptionWidget(title: 'Actions', icon: Icons.sensor_door, page: ScreenActionsGroup(userGroup: userGroup),onReturn: _onReturnFromPage),
              GroupOptionWidget(title: 'Places', icon: Icons.home_work, page: null,onReturn: _onReturnFromPage),
              GroupOptionWidget(title: 'Users', icon: Icons.manage_accounts, page: ScreenListUsers(userGroup: userGroup),onReturn: _onReturnFromPage),
            ],
          ),
    );
  }
}
