import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_form_app/services/sync_service.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var connectionStatus = ConnectivityResult.none.obs;

  final SyncService _syncService = SyncService();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    connectionStatus.value = result.first;

    if (result.first == ConnectivityResult.none) {
      Get.snackbar(
        'Conexión',
        'No hay conexión a internet',
        snackPosition: SnackPosition.TOP,
      );
    }

    if (result.first == ConnectivityResult.mobile ||
        result.first == ConnectivityResult.wifi) {
      _syncService.syncData();
    }
  }

  bool get isConnected => connectionStatus.value != ConnectivityResult.none;
}
