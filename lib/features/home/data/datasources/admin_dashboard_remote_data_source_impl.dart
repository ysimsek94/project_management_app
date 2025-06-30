import 'dart:convert';

import 'package:project_management_app/features/home/data/models/proje_request_model.dart';
import 'package:project_management_app/features/home/data/models/proje_tamamlanma_line.dart';

import '../../../../core/network/api_endpoints.dart';
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
  Future<List<ProjeAdetModel>> getProjeAdet(ProjeRequestModel request) async {
    print('JSON gönderiliyor: ${jsonEncode(request.toJson())}');

    final result = await postList<ProjeAdetModel>(
      ApiEndpoints.getAllProjeDurumAdet,
      <String, dynamic>{},
          (json) => ProjeAdetModel.fromJson(json),
      customMsgs: {
        404: 'Görev listesi bulunamadı.',
        400: 'Hatalı görev sorgusu.',
        500: 'Sunucu hatası. Görev listesi alınamadı.',
      },
    );

    print('Görev listesi döndü: ${result.length} kayıt');
    return result;
  }


  @override
  Future<ChartDashboardData> getProjeTutarPie(ProjeRequestModel request) async {
    // Send the request and get raw JSON list from the service
    final result = await postList<ProjeTamamlanmaLine>(
      ApiEndpoints.getAllProjeToplamTutar,
      <String, dynamic>{},
          (json) => ProjeTamamlanmaLine.fromJson(json),
      customMsgs: {
        404: 'Görev listesi bulunamadı.',
        400: 'Hatalı görev sorgusu.',
        500: 'Sunucu hatası. Görev listesi alınamadı.',
      },
    );

    // Map each ProjeTamamlanmaLine to PieData using its fields
    final series = result.map<PieData>((item) {
      return PieData(
        name: item.departmanAdi,
        value: item.toplamProjeTutari,
      );
    }).toList();

    return ChartDashboardData(series: series);
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
  Future<List<PieData>> getFaaliyetProjeDonut() async {
    final result= await getList<PieData>(
      ApiEndpoints.getFaaliyetProjeDonut(-1),
      (json) => PieData(
        name: json['name'] as String,
        value: (json['value'] as num).toDouble(),
      ),
      customMsgs: {
        404: 'Adet bilgisi bulunamadı.',
        400: 'Geçersiz sorgu.',
        500: 'Sunucu hatası, adet bilgisi alınamadı.',
      },
    );
    return result;
  }
}