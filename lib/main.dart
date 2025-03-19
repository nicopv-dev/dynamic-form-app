import 'package:dynamic_form_app/app/app_router.dart';
import 'package:dynamic_form_app/app/app_theme.dart';
import 'package:dynamic_form_app/helpers/store_binding.dart';
import 'package:get/get.dart';
import 'package:dynamic_form_app/helpers/database_helper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseHelper();
  await db.insertInitialData();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      getPages: AppRouter.routes,
      initialRoute: AppRouter.home,
      initialBinding: StoreBinding(),
      defaultTransition: Transition.native,
    );
  }
}
