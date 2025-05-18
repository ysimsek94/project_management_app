class TaskPhoto {
  final String id;
  final String taskId;
  final String base64Image;
  final DateTime createdAt;

  TaskPhoto({
    required this.id,
    required this.taskId,
    required this.base64Image,
    required this.createdAt,
  });
}