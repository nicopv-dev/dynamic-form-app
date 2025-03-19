import 'package:dynamic_form_app/controllers/network_controller.dart';
import 'package:dynamic_form_app/services/form_service.dart';
import 'package:get/get.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkController>(NetworkController());
    Get.put<FormService>(FormService());
  }
}
