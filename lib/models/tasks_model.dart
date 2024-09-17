class TasksModel{

  String id;
  String title;
  String description;
  int date;
  bool isDone;
  String userId;

  TasksModel(
      {this.id = "",
      required this.title,
      required this.description,
      required this.date,
      required this.userId,
      this.isDone = false});

  TasksModel.fromJson(Map<String, dynamic> jsonMap)
      : this(
          id: jsonMap['id'],
          title: jsonMap['title'],
          description: jsonMap['description'],
          date: jsonMap['date'],
          userId: jsonMap['userId'],
          isDone: jsonMap['isDone'],
        );

  Map<String,dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "isDone": isDone
    };
  }
}