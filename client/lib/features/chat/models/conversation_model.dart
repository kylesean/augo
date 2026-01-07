class Conversation {
  final String id;
  String title;

  Conversation({required this.id, required this.title});

  // For simplicity, we'll just use a basic copyWith for now
  Conversation copyWith({String? id, String? title}) {
    return Conversation(id: id ?? this.id, title: title ?? this.title);
  }
}
