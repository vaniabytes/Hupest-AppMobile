import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart'; // Routing dari folder modular

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Biar async aman
  await GetStorage.init(); // Inisialisasi local storage (GetStorage)

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hupest",
      initialRoute: AppPages.INITIAL, // Contoh: '/home'
      getPages: AppPages.routes, // Semua route didefinisikan di sini
    ),
  );
}
