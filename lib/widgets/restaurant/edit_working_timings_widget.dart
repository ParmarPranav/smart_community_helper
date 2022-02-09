import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/local_working_hour_timings.dart';
import '../../utils/project_constant.dart';

class EditWorkingHourTimingWidget extends StatefulWidget {
  final int index;
  final LocalWorkingHourTimings workingHourTimings;
  final Function addCallBack;
  final Function deleteCallBack;
  final Function openTimeCallBack;
  final Function closeTimeCallBack;

  EditWorkingHourTimingWidget({
    required this.index,
    required this.workingHourTimings,
    required this.addCallBack,
    required this.deleteCallBack,
    required this.openTimeCallBack,
    required this.closeTimeCallBack,
  });

  @override
  _EditWorkingHourTimingWidgetState createState() => _EditWorkingHourTimingWidgetState();
}

class _EditWorkingHourTimingWidgetState extends State<EditWorkingHourTimingWidget> {
  TextEditingController _openTimeController = TextEditingController();
  TextEditingController _closeTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openTimeController.text = widget.workingHourTimings.openTime;
    _closeTimeController.text = widget.workingHourTimings.closeTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: widget.index == 0
                  ? () {
                      widget.addCallBack();
                    }
                  : null,
              child: Icon(
                Icons.add_circle,
                color: widget.index == 0 ? Colors.black : Colors.transparent,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(8)),
              width: 80,
              child: TextField(
                controller: _openTimeController,
                style: ProjectConstant.WorkSansFontRegularTextStyle(
                  fontSize: 16,
                  fontColor: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: '00:00',
                  border: InputBorder.none,
                ),
                readOnly: true,
                showCursor: false,
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _openTimeController.text = '${timeOfDay.hour < 10 ? '0${timeOfDay.hour}' : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}';
                      widget.openTimeCallBack(_openTimeController.text);
                    });
                  }
                },
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'to',
              style: ProjectConstant.WorkSansFontRegularTextStyle(
                fontSize: 18,
                fontColor: Colors.black,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              decoration: DottedDecoration(shape: Shape.box, borderRadius: BorderRadius.circular(8)),
              width: 80,
              child: TextField(
                controller: _closeTimeController,
                style: ProjectConstant.WorkSansFontRegularTextStyle(
                  fontSize: 16,
                  fontColor: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: '00:00',
                  border: InputBorder.none,
                ),
                readOnly: true,
                showCursor: false,
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _closeTimeController.text = '${timeOfDay.hour < 10 ? '0${timeOfDay.hour}' : timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}';
                      widget.closeTimeCallBack(_closeTimeController.text);
                    });
                  }
                },
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Switch(
              value: widget.workingHourTimings.isOpened == 'yes',
              onChanged: (value) {
                setState(() {
                  widget.workingHourTimings.isOpened = value ? 'yes' : 'no';
                });
              },
            ),
            Text(
              widget.workingHourTimings.isOpened == 'yes' ? 'Open' : 'Holiday',
              style: ProjectConstant.WorkSansFontRegularTextStyle(
                fontSize: 14,
                fontColor: Colors.black,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: widget.index != 0
                  ? () {
                      _showDeleteConfirmation();
                    }
                  : null,
              icon: Icon(
                Icons.remove_circle,
                color: widget.index != 0 ? Colors.red : Colors.transparent,
              ),
            )
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation() async {
    var response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete Confirmation'),
          content: Text('Do you really want to delete this item ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    if (response != null) {
      widget.deleteCallBack(widget.index);
    }
  }
}
