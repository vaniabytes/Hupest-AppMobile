import 'package:get/get.dart';

import '../controllers/absen_siswa_controller.dart';

class AbsenSiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsenSiswaController>(
      () => AbsenSiswaController(),
    );
  }
}
