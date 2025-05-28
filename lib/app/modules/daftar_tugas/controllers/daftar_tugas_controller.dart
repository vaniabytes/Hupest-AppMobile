import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarTugasController extends GetxController {
  // Observable variables
  RxList<Map<String, dynamic>> tugasList = <Map<String, dynamic>>[].obs;
  RxInt selectedFilter = 0.obs; // 0: Semua, 1: Aktif, 2: Selesai
  RxBool isSidebarOpen = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final subjectController = TextEditingController();
  RxString selectedPriority = 'Medium'.obs;
  Rx<DateTime> selectedDeadline = DateTime.now().add(const Duration(days: 1)).obs;

  final List<String> priorityOptions = ['Low', 'Medium', 'High'];
  final List<String> subjectOptions = [
    'Matematika',
    'Bahasa Indonesia', 
    'Bahasa Inggris',
    'IPA',
    'IPS',
    'Agama',
    'Seni',
    'Olahraga'
  ];

  @override
  void onInit() {
    super.onInit();
    loadSampleData();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    subjectController.dispose();
    super.onClose();
  }

  void loadSampleData() {
    tugasList.addAll([
      {
        'id': '1',
        'title': 'Essay Bahasa Indonesia',
        'description': 'Menulis essay tentang pahlawan nasional minimal 500 kata',
        'subject': 'Bahasa Indonesia',
        'priority': 'High',
        'deadline': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Latihan Soal Matematika',
        'description': 'Mengerjakan soal-soal tentang persamaan kuadrat halaman 45-50',
        'subject': 'Matematika',
        'priority': 'Medium',
        'deadline': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Presentasi Sejarah',
        'description': 'Presentasi tentang perang dunia ke-2',
        'subject': 'IPS',
        'priority': 'High',
        'deadline': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'isCompleted': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      },
      {
        'id': '4',
        'title': 'Laporan Praktikum IPA',
        'description': 'Membuat laporan hasil praktikum fotosintesis',
        'subject': 'IPA',
        'priority': 'Medium',
        'deadline': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
    ]);
  }

  void setFilter(int index) {
    selectedFilter.value = index;
  }

  List<Map<String, dynamic>> getFilteredTugas() {
    switch (selectedFilter.value) {
      case 1: // Aktif
        return tugasList.where((tugas) => !tugas['isCompleted']).toList();
      case 2: // Selesai
        return tugasList.where((tugas) => tugas['isCompleted']).toList();
      default: // Semua
        return tugasList;
    }
  }

  void toggleTugasStatus(String id) {
    final index = tugasList.indexWhere((tugas) => tugas['id'] == id);
    if (index != -1) {
      tugasList[index]['isCompleted'] = !tugasList[index]['isCompleted'];
      tugasList.refresh();
      
      Get.snackbar(
        tugasList[index]['isCompleted'] ? 'Tugas Selesai!' : 'Tugas Dikembalikan',
        tugasList[index]['isCompleted'] 
            ? 'Selamat! Tugas "${tugasList[index]['title']}" telah diselesaikan' 
            : 'Tugas "${tugasList[index]['title']}" dikembalikan ke daftar aktif',
        backgroundColor: tugasList[index]['isCompleted'] ? Colors.green : Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void showAddTugasDialog() {
    _clearForm();
    Get.dialog(
      _buildTugasDialog(isEdit: false),
      barrierDismissible: false,
    );
  }

  void showEditTugasDialog(Map<String, dynamic> tugas) {
    _populateForm(tugas);
    Get.dialog(
      _buildTugasDialog(isEdit: true, tugasId: tugas['id']),
      barrierDismissible: false,
    );
  }

  Widget _buildTugasDialog({required bool isEdit, String? tugasId}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit Tugas' : 'Tambah Tugas Baru',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5A8151),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Title Field
            Text('Judul Tugas', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul tugas',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Description Field
            Text('Deskripsi', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan deskripsi tugas (opsional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Subject Field
            Text('Mata Pelajaran', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: subjectController.text.isEmpty ? null : subjectController.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
              ),
              hint: const Text('Pilih mata pelajaran'),
              items: subjectOptions.map((subject) {
                return DropdownMenuItem(value: subject, child: Text(subject));
              }).toList(),
              onChanged: (value) {
                subjectController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            
            // Priority and Deadline Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prioritas', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                        value: selectedPriority.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        items: priorityOptions.map((priority) {
                          return DropdownMenuItem(value: priority, child: Text(priority));
                        }).toList(),
                        onChanged: (value) {
                          selectedPriority.value = value ?? 'Medium';
                        },
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deadline', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Obx(() => GestureDetector(
                        onTap: () => _selectDeadline(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '${selectedDeadline.value.day}/${selectedDeadline.value.month}/${selectedDeadline.value.year}',
                                style: GoogleFonts.inter(),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Batal', style: GoogleFonts.inter()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => isEdit ? _updateTugas(tugasId!) : _addTugas(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A8151),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isEdit ? 'Update' : 'Tambah',
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectDeadline() async {
    final picked = await Get.dialog<DateTime>(
      DatePickerDialog(
        initialDate: selectedDeadline.value,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ),
    );
    if (picked != null) {
      selectedDeadline.value = picked;
    }
  }

  void _addTugas() {
    if (_validateForm()) {
      final newTugas = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': titleController.text,
        'description': descriptionController.text,
        'subject': subjectController.text,
        'priority': selectedPriority.value,
        'deadline': selectedDeadline.value.toIso8601String(),
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      tugasList.add(newTugas);
      Get.back();
      
      Get.snackbar(
        'Berhasil!',
        'Tugas "${titleController.text}" berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _updateTugas(String tugasId) {
    if (_validateForm()) {
      final index = tugasList.indexWhere((tugas) => tugas['id'] == tugasId);
      if (index != -1) {
        tugasList[index] = {
          ...tugasList[index],
          'title': titleController.text,
          'description': descriptionController.text,
          'subject': subjectController.text,
          'priority': selectedPriority.value,
          'deadline': selectedDeadline.value.toIso8601String(),
        };
        tugasList.refresh();
        Get.back();
        
        Get.snackbar(
          'Berhasil!',
          'Tugas berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  void deleteTugas(String id) {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus Tugas', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text('Apakah kamu yakin ingin menghapus tugas ini?', style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              tugasList.removeWhere((tugas) => tugas['id'] == id);
              Get.back();
              
              Get.snackbar(
                'Berhasil!',
                'Tugas berhasil dihapus',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
              );
            },
            child: Text('Hapus', style: GoogleFonts.inter(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Judul tugas tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    
    if (subjectController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Mata pelajaran harus dipilih',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    
    return true;
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    subjectController.clear();
    selectedPriority.value = 'Medium';
    selectedDeadline.value = DateTime.now().add(const Duration(days: 1));
  }

  void _populateForm(Map<String, dynamic> tugas) {
    titleController.text = tugas['title'];
    descriptionController.text = tugas['description'];
    subjectController.text = tugas['subject'];
    selectedPriority.value = tugas['priority'];
    selectedDeadline.value = DateTime.parse(tugas['deadline']);
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }
}