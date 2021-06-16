class Question {
  String id;
  String title;
  String description;
  String completion;

  bool finished;

  Question({
    this.id,
    this.title,
    this.description,
    this.completion,
    this.finished,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'title': title,
      'description': description,
      'completion': completion,
      'finished': finished,
    };
  }

  factory Question.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return Question(
      id: map['uuid'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      completion: map['completion'] ?? "",
      finished: map['finished'] ?? false,
    );
  }

  static List<Question> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList.map<Question>((obj) => Question.fromJson(obj)).toList();
  }
}
