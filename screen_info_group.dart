import 'package:flutter/material.dart';
import 'data.dart';
import 'package:problema/InputDecorationTextFormField.dart';


class ScreenInfoGroup extends StatefulWidget {
  late UserGroup userGroup;

  ScreenInfoGroup({super.key,required this.userGroup});

  @override
  State<ScreenInfoGroup> createState() => _ScreenInfoGroupState();
}

class _ScreenInfoGroupState extends State<ScreenInfoGroup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String _title;
  late UserGroup userGroup;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    _title = this.userGroup!.name;
  }
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text("Info ${_title}"),
        ),
        body: Form(
          child: Container(
            margin: EdgeInsetsGeometry.fromLTRB(30,100,30,0),
            child: Column(
              spacing: 40,
              children: [
                InputDecorationTextFormField(name: 'name', exampleInput: 'group name',
                  controller : _nameController,initialValue: userGroup.name,),
                InputDecorationTextFormField(name: 'description', exampleInput: 'put your description here',
                  controller : _descriptionController,minLines: 4,initialValue: userGroup.description,),
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0,30,0,0),
                  child: ElevatedButton(onPressed: () {
                    userGroup.name = _nameController.text;
                    userGroup.description = _descriptionController.text;
                    setState(() {
                      _title = userGroup.name;
                    });
                    ScaffoldMessenger.of(context) .showSnackBar( const SnackBar(content: Text('Group Info Updated')));
                  }, child: Text("Save")),
                )
              ],
            ),
          ),
        )
    );
  }
}
