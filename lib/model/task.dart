class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? remind;
  String? repeat;
  int? color;
  int? isCompleted;

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,
    this.color,
    this.isCompleted,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    repeat = json['repeat'];
    color = json['color'];
    isCompleted = json['isCompleted'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'color': color,
      'isCompleted': isCompleted,
    };
  }
}
