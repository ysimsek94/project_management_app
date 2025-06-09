import 'package:project_management_app/core/constants/gorev_durum_enum.dart';
import 'dart:convert';

import 'package:project_management_app/core/network/base_remote_data_source.dart';
import 'package:project_management_app/core/network/api_endpoints.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';

import '../../../../core/network/api_service.dart';
import '../models/task_list_item_model.dart';
import '../models/task_list_request_model.dart';
import 'task_remote_data_source.dart';

class TaskRemoteDataSourceImpl extends BaseRemoteDataSource implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(ApiService apiService) : super(apiService);


  @override
  Future<List<TaskListItemModel>> getTaskList(TaskListRequestModel request) async {
    print('JSON gönderiliyor: ${jsonEncode(request.toJson())}');

    final result = await postList<TaskListItemModel>(
      ApiEndpoints.getTaskList,
      request.toJson(),
          (json) => TaskListItemModel.fromJson(json),
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
  Future<List<TaskListItemModel>> getAllTaskList() async {
    var result= await getList<TaskListItemModel>(
      ApiEndpoints.getAllTaskList,
          (json) => TaskListItemModel.fromJson(json),
      customMsgs: {
        400: 'Hatalı image sorgusu.',
        404: 'Fotoğraflar bulunamadı.',
        500: 'Sunucu hatası. Fotoğraflar alınamadı.',
      },
    );
    var filtered = result
        .where((task) => task.projeFazGorev != null && task.projeFazGorev!.durum != GorevDurumEnum.tamamlandi)
        .toList();

    print('Görev listesi döndü: ${result.toString()} kayıt');
    return filtered;
  }
  @override
  Future<void> updateTask(TaskRequestModel task) {
    print('TASK UPDATE: ${jsonEncode(task.toJson())}');

    final result=updateItem<void>(
      ApiEndpoints.updateTask,
      task.toJson(),
          (_) => null,
      customMsgs: {
        400: 'Görev güncelleme hatalı.',
        404: 'Görev bulunamadı.',
        500: 'Sunucu hatası. Görev güncellenemedi.',
      },
    );
    return result;
  }

  @override
  Future<List<TaskListItemModel>> getLastTasks(TaskListRequestModel request, {int count = 10}) async {

    final allTasks = await getTaskList(request);
    return allTasks
        .where((task) => task.projeFazGorev.durum != GorevDurumEnum.tamamlandi)
        .take(count)
        .toList();
  }


}