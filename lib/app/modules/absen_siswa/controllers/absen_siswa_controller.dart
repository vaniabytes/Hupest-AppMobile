import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbsenSiswaController extends GetxController {
  // Form controllers
  final TextEditingController keteranganController = TextEditingController();
  
  // Observable variables untuk form
  final selectedJenisIzin = ''.obs;
  final selectedDate = ''.obs;
  final isLoading = false.obs;
  
  // Observable variables untuk statistik (sesuai dengan view)
  final hadirCount = 85.obs;
  final izinCount = 3.obs;
  final sakitCount = 2.obs;
  final alphaCount = 1.obs;
  
  // List riwayat absen (menggunakan Map seperti di view)
  final riwayatAbsen = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRiwayatAbsen();
  }

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }

  // Load data riwayat absen (dummy data sesuai format view)
  void loadRiwayatAbsen() {
    riwayatAbsen.assignAll([
      <String, dynamic>{
        'tanggal': '26 Mei 2025',
        'status': 'Hadir',
        'keterangan': 'Masuk: 07:15 | Pulang: 15:30',
      },
      <String, dynamic>{
        'tanggal': '25 Mei 2025',
        'status': 'Izin',
        'keterangan': 'Keperluan keluarga',
      },
      <String, dynamic>{
        'tanggal': '24 Mei 2025',
        'status': 'Hadir',
        'keterangan': 'Masuk: 07:10 | Pulang: 15:30',
      },
      <String, dynamic>{
        'tanggal': '23 Mei 2025',
        'status': 'Sakit',
        'keterangan': 'Demam tinggi',
      },
      <String, dynamic>{
        'tanggal': '22 Mei 2025',
        'status': 'Hadir',
        'keterangan': 'Masuk: 07:20 | Pulang: 15:30',
      },
    ]);
  }

  // Function untuk set jenis izin (sesuai nama method di view)
  void setJenisIzin(String jenis) {
    selectedJenisIzin.value = jenis;
  }

  // Function untuk memilih tanggal (sesuai nama method di view)
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5A8151),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      selectedDate.value = formatDate(picked);
    }
  }

  // Function untuk format tanggal
  String formatDate(DateTime date) {
    final months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  // Validasi form
  bool validateForm() {
    if (selectedJenisIzin.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih jenis izin terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (selectedDate.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih tanggal izin terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (keteranganController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Keterangan tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  // Function untuk submit izin (sesuai nama method di view)
  Future<void> submitIzin() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create new absen data
      final newAbsen = <String, dynamic>{
        'tanggal': selectedDate.value,
        'status': selectedJenisIzin.value,
        'keterangan': keteranganController.text.trim(),
      };

      // Add to riwayat (insert at beginning)
      riwayatAbsen.insert(0, newAbsen);

      // Update statistik berdasarkan jenis izin
      if (selectedJenisIzin.value.toLowerCase() == 'sakit') {
        sakitCount.value++;
      } else {
        izinCount.value++;
      }

      // Clear form
      clearForm();

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Pengajuan izin telah dikirim',
        backgroundColor: const Color(0xFF5A8151),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim pengajuan izin',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function untuk clear form
  void clearForm() {
    selectedJenisIzin.value = '';
    selectedDate.value = '';
    keteranganController.clear();
  }

  // Function untuk refresh data
  Future<void> refreshData() async {
    isLoading.value = true;
    
    try {
      // Simulate API call to refresh data
      await Future.delayed(const Duration(seconds: 1));
      loadRiwayatAbsen();
      
      Get.snackbar(
        'Berhasil',
        'Data berhasil diperbarui',
        backgroundColor: const Color(0xFF5A8151),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Getter untuk total absen
  int get totalAbsen => hadirCount.value + izinCount.value + sakitCount.value + alphaCount.value;
  
  // Getter untuk persentase kehadiran
  double get persenKehadiran => totalAbsen > 0 ? (hadirCount.value / totalAbsen) * 100 : 0.0;
}