import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/features/activity/domain/usecases/activity_usecases.dart';
import 'core/preferences/AppPreferences.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/slide_right_to_left_page_transitions_builder.dart';
import 'features/task/domain/usecases/task_usecases.dart';
import 'injection.dart';
import 'features/auth/presentation/bloc/login_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Locale, Theme ve yönlendirme ayarlarınız aynı kalıyor.
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

      // Uygulama genelinde ekran ölçeklendirme ve geri tuşu yönetimi
      builder: (context, child) {
        // O anki cihazın gerçek genişlik/yükseklik değerlerini alıyoruz.
        final size = MediaQuery.of(context).size;

        // BoxConstraints => mevcut ekrana ait max genişlik ve yüksekliği içerir.
        ScreenUtil.init(
          context,
          designSize: Size(size.width, size.height),
          minTextAdapt: true,
        );

        return child!;
      },

      initialRoute: '/login',
      routes: {
        '/login': (context) => BlocProvider<LoginCubit>(
          create: (_) => getIt<LoginCubit>(),
          child: const LoginPage(),
        ),
        '/home': (context) => HomePage(
          taskUseCases: getIt<TaskUseCases>(),
          activityUseCases: getIt<ActivityUseCases>(),
        ),
      },
    );
  }
}