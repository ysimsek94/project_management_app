import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_service.dart';
import 'core/preferences/AppPreferences.dart';
import 'core/utils/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/login_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/utils/slide_right_to_left_page_transitions_builder.dart';

import 'features/home/presentation/pages/home_page.dart';
import 'features/project/data/datasources/project_remote_data_source_impl.dart';
import 'features/project/data/repositories/project_repository_impl.dart';
import 'features/project/domain/usecases/get_projects_usecase.dart';
import 'features/task/data/datasources/task_remote_data_source_impl.dart';
import 'features/task/data/repositories/task_repository_impl.dart';

import 'features/task/domain/usecases/task_usecases.dart';
import 'injection.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();

  configureDependencies();

  final dio = Dio();
  final apiService = ApiService(dio);

  // Auth
  final authDataSource = AuthRemoteDataSourceImpl(apiService: apiService);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authDataSource);
  final loginUseCase = LoginUseCase(authRepository);

  // Project
  final projectDataSource = ProjectRemoteDataSourceImpl(apiService);
  final projectRepo = ProjectRepositoryImpl(projectDataSource);
  final getProjectsUseCase = GetProjectsUseCase(projectRepo);

  // Task
  final taskDataSource = TaskRemoteDataSourceImpl(apiService);
  final taskRepo = TaskRepositoryImpl(taskDataSource);
  final taskUseCases = TaskUseCases(taskRepo);

  runApp(MyApp(
    loginUseCase: loginUseCase,
    getProjectsUseCase: getProjectsUseCase,
    taskUseCases: taskUseCases,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final GetProjectsUseCase getProjectsUseCase;
  final TaskUseCases taskUseCases;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.getProjectsUseCase,
    required this.taskUseCases,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: const [Locale('tr')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'Kurumsal Uygulama',
          theme: AppTheme.themes[AppThemeColor.purple]!.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SlideRightToLeftPageTransitionsBuilder(),
                TargetPlatform.iOS: SlideRightToLeftPageTransitionsBuilder(),
              },
            ),
          ),
          routes: {
            '/': (context) => BlocProvider(
              create: (_) => LoginCubit(loginUseCase),
              child: const LoginPage(),
            ),
            '/home': (context) => HomePage(
              getProjectsUseCase: getProjectsUseCase,
              taskUseCases: taskUseCases,
            ),
          },
        );
      },
    );
  }
}
