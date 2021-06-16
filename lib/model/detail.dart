class Detail {
  String id;
  String title;
  String description;
  String completion;

  String type;
  String user;
  String attachment;

  List<Item> items;

  Detail({
    this.id,
    this.title,
    this.description,
    this.completion,
    this.type,
    this.user,
    this.attachment,
    this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'title': title,
      'description': description,
      'completion': completion,
      'type': type,
      'user': user,
      'attachment': attachment,
      'items': (items == null) ? null : items.map((obj) => obj.toJson).toList(),
    };
  }

  factory Detail.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return Detail(
      id: map['uuid'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      completion: map['completion'] ?? "",
      type: map['type'] ?? "",
      user: map['user'] ?? "",
      attachment: map['attachment'] ?? "",
      items: Item.fromJsonList(map['items']),
    );
  }

  static List<Detail> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList.map<Detail>((obj) => Detail.fromJson(obj)).toList();
  }
}

class Item {
  int id;
  String type;
  String question;
  String explanation;

  List<String> answers;
  List<String> corrects;

  Item({
    this.id,
    this.type,
    this.question,
    this.explanation,
    this.answers,
    this.corrects,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'question': question,
      'explanation': explanation,
      'awnsers': answers,
      'correct_awnsers': corrects,
    };
  }

  factory Item.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return Item(
      id: map['uuid'] ?? 0,
      type: map['type'] ?? "",
      question: map['question'] ?? "",
      explanation: map['explanation'] ?? "",
      answers: (map['awnsers'] == null)
          ? []
          : (map['awnsers'] as List).map((e) => e.toString()).toList(),
      corrects: (map['correct_awnsers'] == null)
          ? []
          : (map['correct_awnsers'] as List).map((e) => e.toString()).toList(),
    );
  }

  static List<Item> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList.map<Item>((obj) => Item.fromJson(obj)).toList();
  }
}
