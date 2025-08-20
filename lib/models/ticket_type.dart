class TicketType {
  final int id;
  final String title;
  final String description;

  TicketType({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'],
      title: json['Title'] ?? json['title'],
      description: json['Description'] ?? json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
