import '../../../../core/network/api_service.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/proje_adet_model.dart';
import '../models/chart_dashboard_data.dart';
import '../models/faliyet_line.dart';
import 'admin_dashboard_remote_data_source.dart';

/// Remote data source for Admin Dashboard, using BaseRemoteDataSource helpers
class AdminDashboardRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AdminDashboardRemoteDataSource {
  AdminDashboardRemoteDataSourceImpl(ApiService apiService) : super(apiService);

  @override
  Future<List<ProjeAdetModel>> getProjeAdet() async {
    /*
    return getList<ProjeAdetModel>(
      ApiEndpoints.getProjeAdet,
      (json) => ProjeAdetModel.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Proje adet bilgisi bulunamadı.',
        400: 'Geçersiz proje adet sorgusu.',
        500: 'Sunucu hatası, adet bilgisi alınamadı.',
      },
    );
    */
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> mockJson = [
      {"durumAdi": "Devam Ediyor", "adet": 12},
      {"durumAdi": "Tamamlandı",   "adet": 15},
      {"durumAdi": "İptal Edildi", "adet":  3},
    ];
    return mockJson.map((e) => ProjeAdetModel.fromJson(e)).toList();
  }

  @override
  Future<ChartDashboardData> getProjeTutarPie() async {
    /*
    return getItem<ChartDashboardData>(
      ApiEndpoints.getProjeTutarPie,
      (json) => ChartDashboardData.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Proje tutar bilgisi bulunamadı.',
        400: 'Geçersiz tutar sorgusu.',
        500: 'Sunucu hatası, tutar bilgisi alınamadı.',
      },
    );
    */
    await Future.delayed(const Duration(milliseconds: 300));
    final mockJson = {
      "series": [
        {"name": "IT", "value": 120000.0},
        {"name": "HR", "value": 80000.0},
        {"name": "Finance", "value": 150000.0},
      ]
    };
    return ChartDashboardData.fromJson(mockJson);
  }

  @override
  Future<List<FaliyetLine>> getFaaliyetTamamlandiBar() async {
    /*
    return getList<FaliyetLine>(
      ApiEndpoints.getFaaliyetTamamlandiBar,
      (json) => FaliyetLine.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Faaliyet durumu bulunamadı.',
        400: 'Geçersiz faaliyet sorgusu.',
        500: 'Sunucu hatası, faaliyet bilgisi alınamadı.',
      },
    );
    */
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> mockJson = [
      {
        "faaliyet": {
          "id": 1,
          "departmanId": 10,
          "faliyetTurId": 100,
          "projeId": 1,
          "fazId": 1,
          "islemId": 1,
          "baslangicTarihi": "2023-01-01T00:00:00",
          "bitisTarihi": "2023-01-10T00:00:00",
          "mahalleId": 101,
          "yer": "Merkez",
          "aciklama": "Açıklama örneği",
          "islem": "Başladı",
          "fizikiYuzde": 50.0,
          "durumId": 1,
          "gorevDurumId": 1,
          "geom": {
            "type": "Point",
            "coordinates": [30.1, 41.2]
          }
        },
        "durumu": "Tamamlandı",
        "faaliyetTuru": "Bakım",
        "mahalle": "Yenimahalle",
        "projeAdi": "Altyapı Projesi",
        "departmanAdi": "IT"
      },
      {
        "faaliyet": {
          "id": 2,
          "departmanId": 20,
          "faliyetTurId": 200,
          "projeId": 2,
          "fazId": 2,
          "islemId": 2,
          "baslangicTarihi": "2023-02-01T00:00:00",
          "bitisTarihi": "2023-02-15T00:00:00",
          "mahalleId": 102,
          "yer": "Bölge 2",
          "aciklama": "İkinci faaliyet açıklaması",
          "islem": "Devam Ediyor",
          "fizikiYuzde": 70.0,
          "durumId": 2,
          "gorevDurumId": 2,
          "geom": {
            "type": "Point",
            "coordinates": [29.9, 41.0]
          }
        },
        "durumu": "Devam Ediyor",
        "faaliyetTuru": "Kazı",
        "mahalle": "Fatih",
        "projeAdi": "Yol Genişletme",
        "departmanAdi": "HR"
      }
    ];
    return mockJson.map((e) => FaliyetLine.fromJson(e)).toList();
  }

  @override
  Future<ProjectVsActivity> getFaaliyetProjeDonut() async {
    /*
    return getItem<ProjectVsActivity>(
      ApiEndpoints.getFaaliyetProjeDonut,
      (json) => ProjectVsActivity.fromJson(json as Map<String, dynamic>),
      customMsgs: {
        404: 'Proje vs faaliyet özeti bulunamadı.',
        400: 'Geçersiz özet sorgusu.',
        500: 'Sunucu hatası, özet bilgisi alınamadı.',
      },
    );
    */
    await Future.delayed(const Duration(milliseconds: 300));
    final mockJson = {"proje": 15, "faaliyet": 20};
    return ProjectVsActivity.fromJson(mockJson);
  }
}