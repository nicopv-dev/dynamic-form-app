import 'package:dynamic_form_app/screens/create_form_screen.dart';
import 'package:dynamic_form_app/screens/form_screen.dart';
import 'package:dynamic_form_app/screens/home_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  static const String home = '/';
  static const String form = '/form';
  static const String createForm = '/form/create';

  static final routes = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: createForm, page: () => CreateFormScreen()),
    GetPage(name: form, page: () => FormScreen()),
  ];
}
