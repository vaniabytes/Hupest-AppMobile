import 'package:get/get.dart';

import '../controllers/track_progress_controller.dart';

class TrackProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackProgressController>(
      () => TrackProgressController(),
    );
  }
}
