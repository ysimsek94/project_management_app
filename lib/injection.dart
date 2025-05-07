import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:project_management_app/core/network/api_service.dart';
import 'package:project_management_app/features/profil/data/datasources/profile_remote_data_source_impl.dart';
import 'package:project_management_app/features/profil/data/repositories/profile_repository_impl.dart';
import 'package:project_management_app/features/profil/domain/repositories/profile_repository.dart';
import 'package:project_management_app/features/profil/data/datasources/profile_remote_data_source.dart';

import 'features/profil/domain/usecases/profile_usecases.dart';


// Register the GetIt instance
final getIt = GetIt.instance;

void configureDependencies() {
  // Core HTTP client
  getIt.registerLazySingleton<Dio>(
    () => Dio(),
  );

  // Core network and API services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<Dio>()),
  );

  // ===== Profile Feature =====
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ProfileUseCase>(
    () => ProfileUseCase(getIt<ProfileRepository>()),
  );
}