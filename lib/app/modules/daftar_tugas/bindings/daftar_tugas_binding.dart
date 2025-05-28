import 'package:get/get.dart';
import '../controllers/daftar_tugas_controller.dart';

class DaftarTugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarTugasController>(() => DaftarTugasController());
  }
}
