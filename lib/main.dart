import 'package:attend_app/core/Services/easyLoading.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:attend_app/core/routes_manager/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc_observer.dart';
import 'di/injectable_initializer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
 await SharedPreferenceServices.init();
  runApp(const MyApp());
  Bloc.observer = MyBlocObserver();
  ConfigLoading().showLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesGenerate.onGenerateRoute,
          initialRoute: PagesRoutes.splashScreen,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
