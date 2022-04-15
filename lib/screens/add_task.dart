import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/controller/task_controller.dart';
import 'package:task_reminder/model/task.dart';

import 'package:task_reminder/ui/button.dart';
import 'package:task_reminder/ui/text_field.dart';
import 'package:task_reminder/ui/theme.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("h:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int selectedRemind = 5;
  List<int> remindlist = [5, 10, 15, 20];
  String selectedRepeat = "none";
  List<String> repeatlist = ["none", "daily", "weekly", "monthly"];
  int selectedColor = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task", style: headingStyle),
              InputField(
                title: "Title",
                hint: "Enter Title Here",
                controller: titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter Note Here",
                controller: noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMEd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser(context);
                    },
                    icon: const Icon(Icons.calendar_today_outlined)),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hint: _startTime,
                      title: "Start Time",
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(context, isStartTime: true);
                        },
                        icon: const Icon(Icons.access_time),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: InputField(
                      hint: _endTime,
                      title: "End Time",
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(context, isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                hint: "$selectedRemind minutes early",
                title: "Remind",
                widget: DropdownButton<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRemind = int.parse(newValue!);
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: remindlist.map<DropdownMenuItem<String>>(
                    (int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
              ),
              InputField(
                hint: selectedRepeat,
                title: "Repeat",
                widget: DropdownButton<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRepeat = newValue!;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: repeatlist.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPalette(),
                  Column(
                    children: [
                      const SizedBox(height: 15.0),
                      MyButton(
                          color: bluishClr,
                          width: 120,
                          label: "Create Task",
                          onTap: () {
                            _validateData();
                          }),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.white : Colors.grey[900],
        icon: Icon(
          Icons.warning,
          color: Get.isDarkMode ? Colors.black : Colors.white,
        ),
        colorText: Get.isDarkMode ? Colors.black : Colors.white,
      );
    }
  }

  _addTaskToDB() async {
    int? value = await _taskController.addTask(
      task: Task(
        color: selectedColor,
        date: DateFormat.yMd().format(_selectedDate),
        endTime: _endTime,
        startTime: _startTime,
        isCompleted: 0,
        note: noteController.text,
        title: titleController.text,
        remind: selectedRemind,
        repeat: selectedRepeat,
      ),
    );
    print("my id is $value");
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
            radius: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("images/pp.png"),
            )),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser(BuildContext context, {required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    var _formattedTime = _pickedTime?.format(context);

    if (_pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime!;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime!;
      });
    }
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titletyle,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = index;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: index == 0
                        ? primaryColor
                        : index == 1
                            ? green
                            : pinkClr,
                    radius: 14,
                    child: selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
