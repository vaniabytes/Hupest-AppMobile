import 'package:get/get.dart';

import '../controllers/pemberitahuan_controller.dart';

class PemberitahuanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PemberitahuanController>(
      () => PemberitahuanController(),
    );
  }
}
