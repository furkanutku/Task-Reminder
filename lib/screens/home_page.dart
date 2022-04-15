import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/controller/task_controller.dart';
import 'package:task_reminder/model/task.dart';

import 'package:task_reminder/screens/add_task.dart';
import 'package:task_reminder/services/theme_services.dart';
import 'package:task_reminder/ui/button.dart';
import 'package:task_reminder/ui/task_tile.dart';
import '../services/notification_services.dart';
import '../ui/theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notifyHelper = NotifyHelper();
    notifyHelper.initiliazeNotificication();
    notifyHelper.requestIOSPermissons();
    _taskController.getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTask(),
        ],
      ),
    );
  }

  _showTask() {
    var taskList = _taskController.taskList;

    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            // print(task.toJson());

            if (task.repeat == "daily") {
              // DateTime date = DateFormat.jm().parse(task.startTime.toString());
              // var notifyTime = DateFormat("hh:mm").format(date);

              // notifyHelper.scheduledNotification(
              //   int.parse(notifyTime.toString().split(":")[0]),
              //   int.parse(notifyTime.toString().split(":")[1]),
              //   title: "My Title",
              //   body: "My Body",
              // );
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                      child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, taskList[index], index);
                        },
                        child: TaskTile(taskList[index]),
                      )
                    ],
                  )),
                ),
              );
            }
            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                      child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, taskList[index], index);
                        },
                        child: TaskTile(taskList[index]),
                      )
                    ],
                  )),
                ),
              );
            } else {
              return Container();
            }
          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task, int index) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? Colors.grey[800] : white,
      child: Column(
        children: [
          const SizedBox(
            height: 5.0,
          ),
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[500],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          MyButton(
            color: bluishClr,
            width: MediaQuery.of(context).size.width,
            label:
                task.isCompleted == 1 ? "Task Uncompleted" : "Task Completed",
            onTap: () {
              task.isCompleted == 0
                  ? _taskController.markTaskCompleted(task.id!)
                  : _taskController.markAsToDo(task.id!);
              // _taskController.getTask();

              Get.back();
            },
          ),
          const SizedBox(
            height: 25,
          ),
          MyButton(
            color: pinkClr,
            width: MediaQuery.of(context).size.width,
            label: "Delete Task",
            onTap: () {
              _taskController.delete(task.id!);
              _taskController.getTask();
              Get.back();
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    ));
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.9,
      leading: IconButton(
        onPressed: () {
          ThemeServices().swicthTheme();
          NotifyHelper().displayNotification(
              title: "Theme Changed",
              body: ThemeServices().isDarkMode()
                  ? "Activated Dark Mode"
                  : "Activated Light Mode");

          // notifyHelper.scheduledNotification(
          //     title: "Successfull", body: "After 5 seconds later");
        },
        icon: Get.isDarkMode
            ? Icon(Icons.wb_sunny)
            : Icon(Icons.nightlight_round,
                color: Get.isDarkMode ? Colors.white : Colors.grey[800]),
      ),
      actions: [
        CircleAvatar(
            radius: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "images/pp.png",
              ),
            )),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              color: bluishClr,
              width: 120,
              label: ("+ Add Task"),
              onTap: () async {
                await Get.to(AddTaskPage());
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 10, bottom: 20),
      child: DatePicker(
        DateTime.now(),
        daysCount: 10,
        height: 100,
        width: 90,
        selectionColor: bluishClr,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.grey[900],
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.grey[900],
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.grey[900],
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
}
