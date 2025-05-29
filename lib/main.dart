import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/preferences/AppPreferences.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/slide_right_to_left_page_transitions_builder.dart';
import 'features/project/domain/usecases/get_projects_usecase.dart';
import 'features/task/domain/usecases/task_usecases.dart';
import 'injection.dart';

import 'features/auth/presentation/bloc/login_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences ve diğer asenkron başlangıç işlemleri
  await AppPreferences.init();

  // Tüm bağımlılıkları kaydet
  configureDependencies();

  // Uygulamayı başlat
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: const [Locale('tr')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Kurumsal Uygulama',
        theme: AppTheme.themes[AppThemeColor.teal]!.copyWith(

          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: SlideRightToLeftPageTransitionsBuilder(),
              TargetPlatform.iOS: SlideRightToLeftPageTransitionsBuilder(),
            },
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => BlocProvider<LoginCubit>(
                create: (_) => getIt<LoginCubit>(),
                child: const LoginPage(),
              ),
          '/home': (context) => HomePage(
                getProjectsUseCase: getIt<GetProjectsUseCase>(),
                taskUseCases: getIt<TaskUseCases>(),
              ),
        },
      ),
    );
  }
}
