import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'data.dart';

class ScreenScheduleGroup extends StatefulWidget {
  final UserGroup userGroup;

  const ScreenScheduleGroup({super.key,required this.userGroup});

  @override
  State<ScreenScheduleGroup> createState() => _ScreenScheduleGroupState();
}

class _ScreenScheduleGroupState extends State<ScreenScheduleGroup> {
  late UserGroup userGroup;
  late DateTime now;
  late DateTime fromDate;
  late DateTime toDate;
  final DateFormat dateFormatter = DateFormat.yMd();
  final DateFormat timeFormatter = DateFormat('HH:mm');
  late TimeOfDay fromTime;
  late TimeOfDay toTime;
  late List<bool> weekdays;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    now = DateTime.now();
    fromDate = widget.userGroup.schedule.fromDate;
    toDate = widget.userGroup.schedule.toDate;
    fromTime = widget.userGroup.schedule.fromTime;
    toTime = widget.userGroup.schedule.toTime;
    weekdays = List<bool>.generate(
      7,
          (i) => widget.userGroup.schedule.weekdays.contains(i),
    );
  }

  Future<void> _selectDate(bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate: toDate,
      firstDate: DateTime(now.year-5),
      lastDate: DateTime(now.year+5),
    );

    if (pickedDate == null) return;

    if (isFromDate) {
      if (pickedDate.isAfter(toDate)) {
        _showAlert("Range dates",
            "The From date is after the To date. Please, select a new date range");
        return;
      }
      fromDate = pickedDate;
    }
    else {
      if (pickedDate.isBefore(fromDate)) {
        _showAlert("Range dates",
            "The To date is before the From date. Please, select a new date range");
        return;
      }
      toDate = pickedDate;
    }
    setState(() {});
  }

  Future<void> _selectTime(bool isFromTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isFromTime ? fromTime : toTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime == null) return;

    DateTime pickedHour = DateTime(0,0,0,pickedTime.hour,pickedTime.minute);

    setState(() {
      if (isFromTime) {
        DateTime actualToTime = DateTime(0,0,0,toTime.hour,toTime.minute);
        if (pickedHour.isAfter(actualToTime) ||
            pickedHour.isAtSameMomentAs(actualToTime)){
          _showAlert("Range time",
              "The From time is after the To time. Please, select a new time range");
          return;
        }
        fromTime = pickedTime;
      } else {
        DateTime actualFromTime = DateTime(0,0,0,fromTime.hour,fromTime.minute);
        if (pickedHour.isBefore(actualFromTime) ||
            pickedHour.isAtSameMomentAs(actualFromTime)) {
          _showAlert("Range time",
              "The To time is before the From time. Please, select a new time range");
          return;
        }
        toTime = pickedTime;
      }
    });
  }


  void _showAlert(String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("Schedule ${userGroup.name}"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(40, 70, 40, 0),
        child: Column(
          spacing: 25,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text('From'),
                ),
                Text(dateFormatter.format(fromDate)),
                IconButton(
                    onPressed: () => _selectDate(true),
                    icon: Icon(Icons.calendar_month),
                    color: Colors.lightBlue
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text('To'),
                ),
                Text(dateFormatter.format(toDate)),
                IconButton(
                  onPressed: () => _selectDate(false),
                  icon: Icon(Icons.calendar_month),
                  color: Colors.lightBlue,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekdays',),
                SizedBox(
                    width: 400,
                    child: WeekdaySelector(
                      onChanged: (int day) {
                        setState(() {
                          weekdays[day % 7] = !weekdays[day % 7];
                        });
                      },
                      values: weekdays,
                      shortWeekdays: const [
                        "S", "M", "T", "W", "T", "F", "S"
                      ],

                    )
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text('From'),
                ),
                Text(timeFormatter.format(DateTime(0,0,0,fromTime.hour,fromTime.minute))),
                IconButton(
                    onPressed: () => _selectTime(true),
                    icon: Icon(Icons.access_time),
                    color: Colors.lightBlue
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text('To'),
                ),
                Text(timeFormatter.format(DateTime(0,0,0,toTime.hour,toTime.minute))),
                IconButton(
                  onPressed: () => _selectTime(false),
                  icon: Icon(Icons.access_time),
                  color: Colors.lightBlue,
                )
              ],
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  userGroup.schedule.fromDate = fromDate;
                  userGroup.schedule.toDate = toDate;
                  userGroup.schedule.fromTime = fromTime;
                  userGroup.schedule.toTime = toTime;
                  userGroup.schedule.weekdays = [
                    for (int i = 0; i < 7; i++)
                      if (weekdays[i]) i
                  ];

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved'))
                  );
                },
                child: Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
