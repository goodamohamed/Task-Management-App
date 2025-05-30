class Task {
  final String id; 
  final String name;
  final String description;
  final String priority;
  bool isCompleted;
  DateTime? completionDate;
  DateTime createdAt;

  Task({
    required this.name,
    required this.priority,
    this.description = '',
    this.isCompleted = false,
    this.completionDate,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
      'completionDate': completionDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      priority: map['priority'],
      isCompleted: map['isCompleted'] ?? false,
      completionDate: map['completionDate'] != null 
          ? DateTime.parse(map['completionDate']) 
          : null,
    );
  }
}