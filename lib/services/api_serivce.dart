import 'dart:developer' as dev;

import 'package:dynamic_form_app/controllers/network_controller.dart';
import 'package:get/get.dart';

class ApiSerivce {
  final NetworkController _networkController = Get.find<NetworkController>();

  Future<void> saveForm() async {
    if (_networkController.isConnected) {
      dev.log('Fetch data from API');
    } else {
      dev.log('Save to local database');
    }
  }
}
