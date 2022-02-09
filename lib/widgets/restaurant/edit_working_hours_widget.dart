import 'dart:math';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import '../../models/local_working_hours.dart';
import '../../utils/project_constant.dart';
import '../../utils/string_extension.dart';
import 'edit_working_timings_widget.dart';

class EditWorkingHourWidget extends StatefulWidget {
  final int index;
  final LocalWorkingHours workingHour;
  final Function addCallBack;
  final Function deleteCallBack;
  final Function timeCallBack;

  EditWorkingHourWidget({
    required this.index,
    required this.workingHour,
    required this.addCallBack,
    required this.deleteCallBack,
    required this.timeCallBack,
  });

  @override
  _EditWorkingHourWidgetState createState() => _EditWorkingHourWidgetState();
}

class _EditWorkingHourWidgetState extends State<EditWorkingHourWidget> {
  List _colors = [
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.amber,
    Colors.pink,
    Colors.green,
    Colors.blue,
    Colors.teal,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.red,
    Colors.lightGreen,
    Colors.cyan,
    Colors.orange,
    Colors.yellow,
    Colors.lightBlue,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: DottedDecoration(
        shape: Shape.box,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme(
          contentPadding: EdgeInsets.all(10),
          child: ExpansionTile(
            initiallyExpanded: true,
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: _colors[Random().nextInt(_colors.length)],
              child: Text(
                widget.workingHour.day.substring(0, 1).toUpperCase(),
                style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                  fontSize: 16,
                  fontColor: Colors.white,
                ),
              ),
            ),
            title: Text(
              widget.workingHour.day.capitalize(),
              style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                fontSize: 16,
                fontColor: Colors.black,
              ),
            ),
            childrenPadding: EdgeInsets.only(left: 60),
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.workingHour.localWorkingHourTimingsList.length,
                itemBuilder: (context, index) {
                  return EditWorkingHourTimingWidget(
                    index: index,
                    addCallBack: () => widget.addCallBack(widget.index),
                    deleteCallBack: (index) => widget.deleteCallBack(widget.index, index),
                    openTimeCallBack: (value) => _updateOpenTimeCallBack(value, index),
                    closeTimeCallBack: (value) => _updateCloseTimeCallBack(value, index),
                    workingHourTimings: widget.workingHour.localWorkingHourTimingsList[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOpenTimeCallBack(String value, int index) {
    widget.workingHour.localWorkingHourTimingsList[index].openTime = value;
    widget.timeCallBack(widget.workingHour, widget.index);
  }

  void _updateCloseTimeCallBack(String value, int index) {
    widget.workingHour.localWorkingHourTimingsList[index].closeTime = value;
    widget.timeCallBack(widget.workingHour, widget.index);
  }
}
