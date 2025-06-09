/// Tüm API endpoint URL’lerini merkezi olarak yöneten sınıf
class ApiEndpoints {
  static const login = 'Authentication/v1/token';
  static const getTaskList = 'Proje/v1/kullanici-gorev/getall';
  static const getAllTaskList = 'Proje/v1/kullanici-gorev-dashboard/getall';
  static const updateTask = 'Proje/v1/faz-gorev/update';
  static const getStatusSummary = 'Proje/v1/kullanici-gorev-durum-adet/getall';
  static String getTaskImages(int fazId, int gorevId, bool loadImage) =>
      'Proje/v1/faz-gorev-image/getall/$fazId/$gorevId/$loadImage';
  static const addTaskImage = 'Proje/v1/proje-faz-image/add';
  static String deleteTaskImage(int id) =>
      'Proje/v1/faz-gorev-image/delete/$id';

  static const getActivityList = 'Faliyet/v1/kullanici-gorev/getall';
  static const updateActivity = 'Faliyet/v1/faliyet-gorev/update';
  static String getActivityImages(int faliyetId, int gorevId, bool loadImage) =>
      'Faliyet/v1/faliyet-gorev-image/getall/$faliyetId/$gorevId/$loadImage';
  static const addActivityImage = 'Faliyet/v1/faliyet-image/add';
  static String deleteActivityImage(int id) =>
      'Faliyet/v1/faliyet-image/delete/$id';


  // Admin Dashboard Endpoints
  static const String getProjeAdet = '/Home/GetProjeAdet';
  static const String getProjeTutarPie = '/Home/GetProjeTutarPie';
  static const String getFaaliyetTamamlandiBar = '/Home/GetFaaliyetTamamlandiBar';
  static const String getFaaliyetProjeDonut = '/Home/GetFaaliyetProjeDonut';

}
