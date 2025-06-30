import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:project_management_app/core/network/api_service.dart';
import 'package:project_management_app/features/home/domain/usecases/admin_dashboard_usecase.dart';
import 'package:project_management_app/features/kisi/domain/usecases/kisi_usecases.dart';
import 'package:project_management_app/features/map/data/datasources/map_remote_data_source.dart';
import 'package:project_management_app/features/map/data/datasources/map_remote_data_source_impl.dart';
import 'package:project_management_app/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:project_management_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:project_management_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:project_management_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/activity/data/datasources/activity_remote_data_source.dart';
import 'features/activity/data/datasources/activity_remote_data_source_impl.dart';
import 'features/activity/data/repositories/activity_repository_impl.dart';
import 'features/activity/domain/repositories/activity_repository.dart';
import 'features/activity/domain/usecases/activity_usecases.dart';
import 'features/activity/presentation/bloc/activity_cubit.dart';
import 'features/activity_photo/data/datasources/task_photo_remote_data_source.dart';
import 'features/activity_photo/data/datasources/task_photo_remote_data_source_impl.dart';
import 'features/activity_photo/data/repositories/task_photo_repository_impl.dart';
import 'features/activity_photo/domain/repositories/task_photo_repository.dart';
import 'features/activity_photo/domain/usecases/task_photo_usecases.dart';
import 'features/activity_photo/presentation/bloc/activity_photo_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/home/data/datasources/admin_dashboard_remote_data_source.dart';
import 'features/home/data/datasources/admin_dashboard_remote_data_source_impl.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/datasources/home_remote_data_source_impl.dart';
import 'features/home/data/repositories/admin_dashboard_repository_impl.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/admin_dashboard_repository.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/home_usecases.dart';
import 'features/home/presentation/cubit/admin_dashboard_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/kisi/data/datasources/kisi_remote_data_source.dart';
import 'features/kisi/data/datasources/kisi_remote_data_source_impl.dart';
import 'features/kisi/data/repositories/kisi_repository_impl.dart';
import 'features/kisi/domain/repositories/kisi_repository.dart';
import 'features/kisi/presentation/cubit/kisi_cubit.dart';
import 'features/map/data/repositories/map_repository_impl.dart';
import 'features/map/domain/repositories/map_repository.dart';
import 'features/map/domain/usecases/map_usecases.dart';
import 'features/map/presentation/cubit/map_cubit.dart';
import 'features/profile/domain/usecases/profile_usecases.dart';
import 'package:project_management_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_management_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:project_management_app/features/task/data/datasources/task_remote_data_source_impl.dart';
import 'package:project_management_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:project_management_app/features/task/domain/repositories/task_repository.dart';
import 'package:project_management_app/features/task/domain/usecases/task_usecases.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import 'features/task/data/datasources/task_remote_data_source.dart';
import 'features/task_photo/data/datasources/task_photo_remote_data_source.dart';
import 'features/task_photo/data/datasources/task_photo_remote_data_source_impl.dart';
import 'features/task_photo/data/repositories/task_photo_repository_impl.dart';
import 'features/task_photo/domain/repositories/task_photo_repository.dart';
import 'features/task_photo/domain/usecases/task_photo_usecases.dart';
import 'features/task_photo/presentation/bloc/task_photo_cubit.dart';

// Register the GetIt instance
final getIt = GetIt.instance;

void configureDependencies() {
  // Core HTTP client
  getIt.registerLazySingleton<Dio>(
    () => Dio(),
  );
  // Core network and API services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<Dio>(), baseUrl: "http://10.100.8.60:8051/api/"),
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

  // ===== Auth Feature =====
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginUseCase>()),
  );

  // ===== Task Feature =====
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt<TaskRemoteDataSource>()),
  );
  getIt.registerLazySingleton<TaskUseCases>(
    () => TaskUseCases(getIt<TaskRepository>()),
  );
  getIt.registerFactory<TaskCubit>(
    () => TaskCubit(getIt<TaskUseCases>()),
  );

  // ===== TaskPhoto Feature =====
  getIt.registerLazySingleton<TaskPhotoRemoteDataSource>(
    () => TaskPhotoRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<TaskPhotoRepository>(
    () => TaskPhotoRepositoryImpl(getIt<TaskPhotoRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetTaskPhotosUseCase>(
    () => GetTaskPhotosUseCase(getIt<TaskPhotoRepository>()),
  );
  getIt.registerLazySingleton<UploadTaskPhotoUseCase>(
    () => UploadTaskPhotoUseCase(getIt<TaskPhotoRepository>()),
  );
  getIt.registerLazySingleton<DeleteTaskPhotoUseCase>(
    () => DeleteTaskPhotoUseCase(getIt<TaskPhotoRepository>()),
  );
  getIt.registerFactory<TaskPhotoCubit>(
    () => TaskPhotoCubit(
      getIt<GetTaskPhotosUseCase>(),
      getIt<UploadTaskPhotoUseCase>(),
      getIt<DeleteTaskPhotoUseCase>(),
    ),
  );

  // ===== Home Feature =====
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<HomeUseCases>(
    () => HomeUseCases(getIt<HomeRepository>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<HomeUseCases>(), getIt<TaskCubit>()),
  );
  // ===== AdminDashboard Feature =====
  getIt.registerLazySingleton<AdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AdminDashboardRepository>(
    () => AdminDashboardRepositoryImpl(getIt<AdminDashboardRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AdminDashboardDataUseCases>(
    () => AdminDashboardDataUseCases(getIt<AdminDashboardRepository>()),
  );
  getIt.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(getIt<AdminDashboardDataUseCases>()),
  );

  // ===== Activity Feature =====
  getIt.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(getIt<ActivityRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ActivityUseCases>(
    () => ActivityUseCases(getIt<ActivityRepository>()),
  );
  getIt.registerFactory<ActivityCubit>(
    () => ActivityCubit(getIt<ActivityUseCases>()),
  );

  // ===== ActivityPhoto Feature =====
  getIt.registerLazySingleton<ActivityPhotoRemoteDataSource>(
    () => ActivityPhotoRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ActivityPhotoRepository>(
    () => ActivityPhotoRepositoryImpl(getIt<ActivityPhotoRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetActivityPhotosUseCase>(
    () => GetActivityPhotosUseCase(getIt<ActivityPhotoRepository>()),
  );
  getIt.registerLazySingleton<UploadActivityPhotoUseCase>(
    () => UploadActivityPhotoUseCase(getIt<ActivityPhotoRepository>()),
  );
  getIt.registerLazySingleton<DeleteActivityPhotoUseCase>(
    () => DeleteActivityPhotoUseCase(getIt<ActivityPhotoRepository>()),
  );
  getIt.registerFactory<ActivityPhotoCubit>(
    () => ActivityPhotoCubit(
      getIt<GetActivityPhotosUseCase>(),
      getIt<UploadActivityPhotoUseCase>(),
      getIt<DeleteActivityPhotoUseCase>(),
    ),
  );

  // ===== Map Feature =====
  getIt.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: getIt<MapRemoteDataSource>()),
  );
  getIt.registerLazySingleton<MapUseCases>(
    () => MapUseCases(mapRepository: getIt<MapRepository>()),
  );
  getIt.registerFactory<MapCubit>(
    () => MapCubit(getIt<MapUseCases>()),
  );

  // ===== Kisi Feature =====
  getIt.registerLazySingleton<KisiRemoteDataSource>(
        () => KisiRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<KisiRepository>(
        () => KisiRepositoryImpl(getIt<KisiRemoteDataSource>()),
  );
  getIt.registerLazySingleton<KisiUseCases>(
        () => KisiUseCases(getIt<KisiRepository>()),
  );
  getIt.registerFactory<KisiCubit>(
        () => KisiCubit(getIt<KisiUseCases>()),
  );
}
