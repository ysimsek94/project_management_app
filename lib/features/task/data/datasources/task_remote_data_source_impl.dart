import '../../../../core/network/api_service.dart';
import '../models/task_model.dart';
import 'task_remote_data_source.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiService apiService;

  TaskRemoteDataSourceImpl(this.apiService);

  List<Map<String, dynamic>> _mockTaskStore = [];

  // @override
  // Future<List<TaskModel>> getTasksByProjectId(String projectId) async {
  //   final response = await apiService.get('https://yourapi.com/projects/$projectId/tasks');
  //   final List data = response.data;
  //   return data.map((e) => TaskModel.fromJson(e)).toList();
  // }
  @override
  Future<List<TaskModel>> getTasksByProjectId(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simüle edilen gecikme

    final mockJsonList = [
      {
        "id": "1",
        "title": "Veritabanı Tasarımı",
        "description": "Entity yapısı belirlenecek",
        "status": "yapılacak",
        "dueTime": "2025-04-28 08:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "2",
        "title": "API Endpoints",
        "description": "Kullanıcı işlemleri API geliştirme",
        "status": "devam ediyor",
        "dueTime": "2025-04-28 10:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "3",
        "title": "Frontend Entegrasyonu",
        "description": "Login ve Dashboard ekranları",
        "status": "tamamlandı",
        "dueTime": "2025-04-28 11:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "4",
        "title": "Kullanıcı Testleri",
        "description": "Beta kullanıcı testleri yapılacak",
        "status": "bekliyor",
        "dueTime": "2025-04-28 12:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "5",
        "title": "Sunucu Kurulumu",
        "description": "Yeni sunucu kurulacak",
        "status": "yapılacak",
        "dueTime": "2025-04-28 13:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "6",
        "title": "Veri Tabanı Yedekleme",
        "description": "Haftalık yedekleme yapılacak",
        "status": "tamamlandı",
        "dueTime": "2025-04-28 14:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "7",
        "title": "Dokümantasyon",
        "description": "Proje dökümantasyonu yazılacak",
        "status": "devam ediyor",
        "dueTime": "2025-04-28 15:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "8",
        "title": "Müşteri Toplantısı",
        "description": "Önemli müşteri ile toplantı",
        "status": "acil",
        "dueTime": "2025-04-28 16:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "9",
        "title": "Sürüm Yayını",
        "description": "Yeni versiyon yayına alınacak",
        "status": "bekliyor",
        "dueTime": "2025-04-28 17:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "10",
        "title": "Proje Kapanışı",
        "description": "Kapanış raporu hazırlanacak",
        "status": "yapılacak",
        "dueTime": "2025-04-28 18:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
    ];
    final sortedList = mockJsonList
      ..sort((a, b) =>
          (a['dueTime'] ?? '').toString().compareTo((b['dueTime'] ?? '').toString()));

    return sortedList.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<List<TaskModel>> getTaskList(String tarih) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simüle edilen gecikme

    final mockJsonList = [
      {
        "id": "1",
        "title": "Veritabanı Tasarımı",
        "description": "Entity yapısı belirlenecek",
        "status": "yapılacak",
        "dueTime": "2025-04-28 08:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "2",
        "title": "API Endpoints",
        "description": "Kullanıcı işlemleri API geliştirme",
        "status": "devam ediyor",
        "dueTime": "2025-04-28 10:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "3",
        "title": "Frontend Entegrasyonu",
        "description": "Login ve Dashboard ekranları",
        "status": "tamamlandı",
        "dueTime": "2025-04-28 11:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "4",
        "title": "Kullanıcı Testleri",
        "description": "Beta kullanıcı testleri yapılacak",
        "status": "bekliyor",
        "dueTime": "2025-04-28 12:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "5",
        "title": "Sunucu Kurulumu",
        "description": "Yeni sunucu kurulacak",
        "status": "yapılacak",
        "dueTime": "2025-04-28 13:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "6",
        "title": "Veri Tabanı Yedekleme",
        "description": "Haftalık yedekleme yapılacak",
        "status": "tamamlandı",
        "dueTime": "2025-04-28 14:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "7",
        "title": "Dokümantasyon",
        "description": "Proje dökümantasyonu yazılacak",
        "status": "devam ediyor",
        "dueTime": "2025-04-28 15:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "8",
        "title": "Müşteri Toplantısı",
        "description": "Önemli müşteri ile toplantı",
        "status": "acil",
        "dueTime": "2025-04-28 16:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "9",
        "title": "Sürüm Yayını",
        "description": "Yeni versiyon yayına alınacak",
        "status": "bekliyor",
        "dueTime": "2025-04-28 17:00",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
      {
        "id": "10",
        "title": "Proje Kapanışı",
        "description": "Kapanış raporu hazırlanacak",
        "status": "yapılacak",
        "dueTime": "2025-04-28 18:30",
        "latitude": 40.9905,
        "longitude": 29.0282,
      },
    ];
    final sortedList = mockJsonList
      ..sort((a, b) =>
          (a['dueTime'] ?? '').toString().compareTo((b['dueTime'] ?? '').toString()));

    return sortedList.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<TaskModel> addTask( TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTask = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "title": task.title,
      "description": task.description,
      "status": task.status,
      "dueTime": "2025-04-30 10:00",
      "latitude": 40.9905,
      "longitude": 29.0282,
    };
    _mockTaskStore.add(newTask);
    print("Mock görev eklendi: $newTask.title");
    return TaskModel.fromJson(newTask);
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTaskStore.removeWhere((task) => task['id'] == taskId);
    print("Mock görev silindi: $taskId");
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockTaskStore.indexWhere((element) => element['id'] == task.id);
    if (index != -1) {
      _mockTaskStore[index] = task.toJson();
      print("Mock görev güncellendi: ${task.id}");
    }
  }

  @override
  Future<TaskModel> getTaskById(int taskId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simüle edilen gecikme

    final mockJson = {
      "id": taskId.toString(),
      "title": "Veritabanı Tasarımı",
      "description": "Entity yapısı belirlenecek",
      "status": "yapılacak",
      "dueTime": "2025-04-28 08:30",
      "latitude": 40.9905,
      "longitude": 29.0282,
    };
    return TaskModel.fromJson(mockJson);
  }
}