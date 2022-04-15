import 'package:get/get.dart';
import 'package:task_reminder/database/database_helper.dart';
import 'package:task_reminder/model/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int?> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(int id) {
    DBHelper.delete(id);
  }

  void markTaskCompleted(int id) async {
    await DBHelper.updateAsComplete(id);
    getTask();
  }

  void markAsToDo(int id) {
    DBHelper.updateAsTodo(id);
    getTask();
  }
}
