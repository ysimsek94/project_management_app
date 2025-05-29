/// Tüm API endpoint URL’lerini merkezi olarak yöneten sınıf
class ApiEndpoints {
  static const login = 'Authentication/v1/token';
  static const getTaskList = 'Proje/v1/kullanici-gorev/getall';
  static const updateTask = 'Proje/v1/faz-gorev/update';
  static const getStatusSummary = 'Proje/v1/kullanici-gorev-durum-adet/getall';
  static String getTaskImages(int fazId, int gorevId, bool loadImage) =>
      'Proje/v1/faz-gorev-image/getall/$fazId/$gorevId/$loadImage';
  static const addTaskImage = 'Proje/v1/proje-faz-image/add';
  static String deleteTaskImage(int id) =>
      'Proje/v1/faz-gorev-image/delete/$id';
}
