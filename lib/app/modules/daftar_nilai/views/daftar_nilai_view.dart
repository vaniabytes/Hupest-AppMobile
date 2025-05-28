import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_navbar_view.dart';
import '../../../widgets/profile_sidebar.dart';
import '../controllers/daftar_nilai_controller.dart';

class DaftarNilaiView extends StatelessWidget {
  const DaftarNilaiView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DaftarNilaiController());

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5DD),
      body: SafeArea(
        child: Stack(
          children: [
            // Konten Utama
            Column(
              children: [
                CustomNavbarView(
                  selectedIndex: 0,
                  userName: "Jihan",
                  onTabSelected: (index) {
                    if (index == 1) {
                      Get.toNamed('/home');
                    } else if (index == 2) {
                      Get.toNamed('/daftar-tugas');
                    }
                  },
                  onProfileTap: () => controller.toggleSidebar(),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: TextField(
                                  onChanged: controller.filterNilai,
                                  decoration: InputDecoration(
                                    hintText: "Cari mata pelajaran...",
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey[500],
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Obx(() {
                              final List<String> semesterOptions = [
                                "Semua Semester",
                                "Semester 1 (Kelas VII)",
                                "Semester 2 (Kelas VII)",
                                "Semester 3 (Kelas VIII)",
                                "Semester 4 (Kelas VIII)",
                                "Semester 5 (Kelas IX)",
                                "Semester 6 (Kelas IX)"
                              ];

                              String currentValue = controller.selectedSemester.value;
                              if (!semesterOptions.contains(currentValue)) {
                                currentValue = "Semua Semester";
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  controller.selectedSemester.value = "Semua Semester";
                                });
                              }

                              return Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: currentValue,
                                    hint: Text(
                                      "Semester",
                                      style: GoogleFonts.inter(
                                        color: Colors.grey[500],
                                        fontSize: 14,
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: "Semua Semester",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.analytics_outlined,
                                              size: 16,
                                              color: const Color(0xFF5A8151),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Semua Semester",
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF5A8151),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...semesterOptions.skip(1).map((semester) {
                                        return DropdownMenuItem(
                                          value: semester,
                                          child: Text(
                                            semester,
                                            style: GoogleFonts.inter(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: controller.changeSemester,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 24), // Increased spacing

                        // Summary Card - Diperkecil dan disesuaikan
                        Obx(() => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: controller.selectedSemester.value == "Semua Semester"
                              ? const LinearGradient(
                                  colors: [Color(0xFF5A8151), Color(0xFF5A8151)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFF5A8151), Color(0xFF6B9462)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (controller.selectedSemester.value == "Semua Semester" 
                                  ? const Color(0xFF2D5A3D) 
                                  : const Color(0xFF5A8151)).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header dengan info semester
                              if (controller.selectedSemester.value == "Semua Semester")
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Nilai Akhir (Semester 1-6)",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.selectedSemester.value == "Semua Semester"
                                            ? "Rata-rata Nilai Akhir"
                                            : "Rata-rata Nilai",
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller.selectedSemester.value == "Semua Semester"
                                            ? "84.8"
                                            : _calculateSemesterAverage(controller.selectedSemester.value).toStringAsFixed(1),
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.selectedSemester.value == "Semua Semester"
                                            ? "Total Mapel"
                                            : "Total Mata Pelajaran",
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${controller.selectedSemester.value == "Semua Semester" ? "10" : _getSubjectCount(controller.selectedSemester.value)}",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      controller.selectedSemester.value == "Semua Semester"
                                        ? Icons.emoji_events
                                        : Icons.trending_up,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 24), // Increased spacing before table

                        // Daftar Nilai atau Tabel Semester
                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF5A8151),
                                ),
                              );
                            }

                            // Jika semua semester, tampilkan tabel rangkuman
                            if (controller.selectedSemester.value == "Semua Semester") {
                              return _buildSemesterSummaryTable();
                            }

                            // Untuk semester spesifik, tampilkan daftar nilai
                            final List<Map<String, dynamic>> nilaiData = _getNilaiForSemester(controller.selectedSemester.value);

                            return ListView.builder(
                              itemCount: nilaiData.length,
                              itemBuilder: (context, index) {
                                final nilai = nilaiData[index];
                                return _buildNilaiCard(nilai, false);
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Sidebar + overlay penutup
            Obx(() {
              if (!controller.showSidebar.value) return const SizedBox.shrink();

              return Stack(
                children: [
                  // Overlay hitam semi transparan
                  GestureDetector(
                    onTap: controller.toggleSidebar,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // Sidebar muncul dari kiri
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ProfileSidebar(
                      onClose: controller.toggleSidebar,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // Calculate average for specific semester
  double _calculateSemesterAverage(String semester) {
    final nilaiData = _getNilaiForSemester(semester);
    if (nilaiData.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var data in nilaiData) {
      total += data['nilaiAkhir'];
    }
    return total / nilaiData.length;
  }

  // Fungsi untuk mendapat jumlah mata pelajaran per semester
  int _getSubjectCount(String semester) {
    final nilaiData = _getNilaiForSemester(semester);
    return nilaiData.length;
  }

  // Tabel rangkuman semester dengan warna hijau
  Widget _buildSemesterSummaryTable() {
    final semesterData = [
      {'semester': 'Semester 1 (VII)', 'rataRata': 85.2, 'tertinggi': 92.0, 'terendah': 78.0, 'mapel': 10},
      {'semester': 'Semester 2 (VII)', 'rataRata': 83.8, 'tertinggi': 90.0, 'terendah': 75.0, 'mapel': 10},
      {'semester': 'Semester 3 (VIII)', 'rataRata': 86.1, 'tertinggi': 95.0, 'terendah': 80.0, 'mapel': 10},
      {'semester': 'Semester 4 (VIII)', 'rataRata': 84.5, 'tertinggi': 91.0, 'terendah': 77.0, 'mapel': 10},
      {'semester': 'Semester 5 (IX)', 'rataRata': 85.9, 'tertinggi': 93.0, 'terendah': 79.0, 'mapel': 10},
      {'semester': 'Semester 6 (IX)', 'rataRata': 84.3, 'tertinggi': 89.0, 'terendah': 76.0, 'mapel': 10},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header tabel dengan warna hijau
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5A8151), Color(0xFF6B9462)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Ringkasan Nilai Per Semester",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Tabel data
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: semesterData.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final data = semesterData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['semester'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${data['mapel']} Mata Pelajaran",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              "Rata-rata",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              (data['rataRata'] as double).toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getGradeColor(data['rataRata'] as double),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "Max",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              (data['tertinggi'] as double).toStringAsFixed(0),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "Min",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              (data['terendah'] as double).toStringAsFixed(0),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendapat data nilai berdasarkan semester
  List<Map<String, dynamic>> _getNilaiForSemester(String semester) {
    final Map<String, List<Map<String, dynamic>>> allData = {
      'Semester 1 (Kelas VII)': [
        {'mataPelajaran': 'Matematika', 'guru': 'Bu Sari Dewi', 'uts': 85.0, 'uas': 88.0, 'tugas': 90.0, 'nilaiAkhir': 87.7},
        {'mataPelajaran': 'Bahasa Indonesia', 'guru': 'Pak Ahmad Wijaya', 'uts': 82.0, 'uas': 85.0, 'tugas': 88.0, 'nilaiAkhir': 85.0},
        {'mataPelajaran': 'IPA', 'guru': 'Bu Rina Sari', 'uts': 78.0, 'uas': 80.0, 'tugas': 85.0, 'nilaiAkhir': 81.0},
        {'mataPelajaran': 'IPS', 'guru': 'Pak Hendro', 'uts': 77.0, 'uas': 79.0, 'tugas': 83.0, 'nilaiAkhir': 79.7},
        {'mataPelajaran': 'Bahasa Inggris', 'guru': 'Miss Diana', 'uts': 84.0, 'uas': 86.0, 'tugas': 89.0, 'nilaiAkhir': 86.3},
        {'mataPelajaran': 'Pendidikan Pancasila', 'guru': 'Bu Fitri', 'uts': 88.0, 'uas': 90.0, 'tugas': 92.0, 'nilaiAkhir': 90.0},
        {'mataPelajaran': 'Seni Budaya', 'guru': 'Pak Bambang', 'uts': 85.0, 'uas': 87.0, 'tugas': 89.0, 'nilaiAkhir': 87.0},
        {'mataPelajaran': 'PJOK', 'guru': 'Pak Agus', 'uts': 90.0, 'uas': 88.0, 'tugas': 92.0, 'nilaiAkhir': 90.0},
        {'mataPelajaran': 'Prakarya', 'guru': 'Bu Lina', 'uts': 86.0, 'uas': 84.0, 'tugas': 88.0, 'nilaiAkhir': 86.0},
        {'mataPelajaran': 'Bahasa Jawa', 'guru': 'Pak Sutrisno', 'uts': 78.0, 'uas': 80.0, 'tugas': 82.0, 'nilaiAkhir': 80.0},
      ],
      'Semester 2 (Kelas VII)': [
        {'mataPelajaran': 'Matematika', 'guru': 'Bu Sari Dewi', 'uts': 83.0, 'uas': 85.0, 'tugas': 87.0, 'nilaiAkhir': 85.0},
        {'mataPelajaran': 'Bahasa Indonesia', 'guru': 'Pak Ahmad Wijaya', 'uts': 80.0, 'uas': 82.0, 'tugas': 85.0, 'nilaiAkhir': 82.3},
        {'mataPelajaran': 'IPA', 'guru': 'Bu Rina Sari', 'uts': 76.0, 'uas': 78.0, 'tugas': 82.0, 'nilaiAkhir': 78.7},
        {'mataPelajaran': 'IPS', 'guru': 'Pak Hendro', 'uts': 75.0, 'uas': 77.0, 'tugas': 80.0, 'nilaiAkhir': 77.3},
        {'mataPelajaran': 'Bahasa Inggris', 'guru': 'Miss Diana', 'uts': 86.0, 'uas': 88.0, 'tugas': 90.0, 'nilaiAkhir': 88.0},
        {'mataPelajaran': 'Pendidikan Pancasila', 'guru': 'Bu Fitri', 'uts': 85.0, 'uas': 87.0, 'tugas': 89.0, 'nilaiAkhir': 87.0},
        {'mataPelajaran': 'Seni Budaya', 'guru': 'Pak Bambang', 'uts': 82.0, 'uas': 84.0, 'tugas': 86.0, 'nilaiAkhir': 84.0},
        {'mataPelajaran': 'PJOK', 'guru': 'Pak Agus', 'uts': 88.0, 'uas': 90.0, 'tugas': 91.0, 'nilaiAkhir': 89.7},
        {'mataPelajaran': 'Prakarya', 'guru': 'Bu Lina', 'uts': 84.0, 'uas': 86.0, 'tugas': 85.0, 'nilaiAkhir': 85.0},
        {'mataPelajaran': 'Bahasa Jawa', 'guru': 'Pak Sutrisno', 'uts': 76.0, 'uas': 78.0, 'tugas': 80.0, 'nilaiAkhir': 78.0},
      ],
      'Semester 3 (Kelas VIII)': [
        {'mataPelajaran': 'Matematika', 'guru': 'Bu Sari Dewi', 'uts': 87.0, 'uas': 89.0, 'tugas': 92.0, 'nilaiAkhir': 89.3},
        {'mataPelajaran': 'Bahasa Indonesia', 'guru': 'Pak Ahmad Wijaya', 'uts': 84.0, 'uas': 86.0, 'tugas': 88.0, 'nilaiAkhir': 86.0},
        {'mataPelajaran': 'IPA', 'guru': 'Bu Rina Sari', 'uts': 80.0, 'uas': 83.0, 'tugas': 86.0, 'nilaiAkhir': 83.0},
        {'mataPelajaran': 'IPS', 'guru': 'Pak Hendro', 'uts': 82.0, 'uas': 85.0, 'tugas': 87.0, 'nilaiAkhir': 84.7},
        {'mataPelajaran': 'Bahasa Inggris', 'guru': 'Miss Diana', 'uts': 90.0, 'uas': 92.0, 'tugas': 95.0, 'nilaiAkhir': 92.3},
        {'mataPelajaran': 'Pendidikan Pancasila', 'guru': 'Bu Fitri', 'uts': 89.0, 'uas': 91.0, 'tugas': 93.0, 'nilaiAkhir': 91.0},
        {'mataPelajaran': 'Seni Budaya', 'guru': 'Pak Bambang', 'uts': 86.0, 'uas': 88.0, 'tugas': 90.0, 'nilaiAkhir': 88.0},
        {'mataPelajaran': 'PJOK', 'guru': 'Pak Agus', 'uts': 92.0, 'uas': 94.0, 'tugas': 95.0, 'nilaiAkhir': 93.7},
        {'mataPelajaran': 'Prakarya', 'guru': 'Bu Lina', 'uts': 85.0, 'uas': 87.0, 'tugas': 89.0, 'nilaiAkhir': 87.0},
        {'mataPelajaran': 'Bahasa Jawa', 'guru': 'Pak Sutrisno', 'uts': 80.0, 'uas': 82.0, 'tugas': 84.0, 'nilaiAkhir': 82.0},
      ],
      'Semester 4 (Kelas VIII)': [
        {'mataPelajaran': 'Matematika', 'guru': 'Bu Sari Dewi', 'uts': 84.0, 'uas': 86.0, 'tugas': 88.0, 'nilaiAkhir': 86.0},
        {'mataPelajaran': 'Bahasa Indonesia', 'guru': 'Pak Ahmad Wijaya', 'uts': 81.0, 'uas': 83.0, 'tugas': 85.0, 'nilaiAkhir': 83.0},
        {'mataPelajaran': 'IPA', 'guru': 'Bu Rina Sari', 'uts': 77.0, 'uas': 80.0, 'tugas': 83.0, 'nilaiAkhir': 80.0},
        {'mataPelajaran': 'IPS', 'guru': 'Pak Hendro', 'uts': 79.0, 'uas': 82.0, 'tugas': 84.0, 'nilaiAkhir': 81.7},
        {'mataPelajaran': 'Bahasa Inggris', 'guru': 'Miss Diana', 'uts': 87.0, 'uas': 89.0, 'tugas': 91.0, 'nilaiAkhir': 89.0},
        {'mataPelajaran': 'Pendidikan Pancasila', 'guru': 'Bu Fitri', 'uts': 86.0, 'uas': 88.0, 'tugas': 90.0, 'nilaiAkhir': 88.0},
        {'mataPelajaran': 'Seni Budaya', 'guru': 'Pak Bambang', 'uts': 83.0, 'uas': 85.0, 'tugas': 87.0, 'nilaiAkhir': 85.0},
        {'mataPelajaran': 'PJOK', 'guru': 'Pak Agus', 'uts': 89.0, 'uas': 91.0, 'tugas': 92.0, 'nilaiAkhir': 90.7},
        {'mataPelajaran': 'Prakarya', 'guru': 'Bu Lina', 'uts': 82.0, 'uas': 84.0, 'tugas': 86.0, 'nilaiAkhir': 84.0},
        {'mataPelajaran': 'Bahasa Jawa', 'guru': 'Pak Sutrisno', 'uts': 77.0, 'uas': 79.0, 'tugas': 81.0, 'nilaiAkhir': 79.0},
      ],
      'Semester 5 (Kelas IX)': [
        {'mataPelajaran': 'Matematika', 'guru': 'Bu Sari Dewi', 'uts': 86.0, 'uas': 88.0, 'tugas': 90.0, 'nilaiAkhir': 88.0},
        {'mataPelajaran': 'Bahasa Indonesia', 'guru': 'Pak Ahmad Wijaya', 'uts': 85.0, 'uas': 87.0, 'tugas': 89.0, 'nilaiAkhir': 87.0},
        {'mataPelajaran': 'IPA', 'guru': 'Bu Rina Sari', 'uts': 82.0, 'uas': 85.0, 'tugas': 88.0, 'nilaiAkhir': 85.0},
        {'mataPelajaran': 'IPS', 'guru': 'Pak Hendro', 'uts': 83.0, 'uas': 86.0, 'tugas': 88.0, 'nilaiAkhir': 85.7},
        {'mataPelajaran': 'Bahasa Inggris', 'guru': 'Miss Diana', 'uts': 91.0, 'uas': 93.0, 'tugas': 95.0, 'nilaiAkhir': 93.0},
        {'mataPelajaran': 'Pendidikan Pancasila', 'guru': 'Bu Fitri', 'uts': 88.0, 'uas': 90.0, 'tugas': 92.0, 'nilaiAkhir': 90.0},
        {'mataPelajaran': 'Seni Budaya', 'guru': 'Pak Bambang', 'uts': 84.0, 'uas': 86.0, 'tugas': 88.0, 'nilaiAkhir': 86.0},
        {'mataPelajaran': 'PJOK', 'guru': 'Pak Agus', 'uts': 90.0, 'uas': 92.0, 'tugas': 94.0, 'nilaiAkhir': 92.0},
        {'mataPelajaran': 'Prakarya', 'guru': 'Bu Lina', 'uts': 87.0, 'uas': 89.0, 'tugas': 91.0, 'nilaiAkhir': 89.0},
        {'mataPelajaran': 'Bahasa Jawa', 'guru': 'Pak Sutrisno', 'uts': 79.0, 'uas': 81.0, 'tugas': 83.0, 'nilaiAkhir': 81.0},
      ],
      'Semester 6 (Kelas IX)': [
        {'mataPelajaran': 'Matematika', 'guru': 'Bu Sari Dewi', 'uts': 83.0, 'uas': 85.0, 'tugas': 87.0, 'nilaiAkhir': 85.0},
        {'mataPelajaran': 'Bahasa Indonesia', 'guru': 'Pak Ahmad Wijaya', 'uts': 82.0, 'uas': 84.0, 'tugas': 86.0, 'nilaiAkhir': 84.0},
        {'mataPelajaran': 'IPA', 'guru': 'Bu Rina Sari', 'uts': 80.0, 'uas': 82.0, 'tugas': 85.0, 'nilaiAkhir': 82.3},
        {'mataPelajaran': 'IPS', 'guru': 'Pak Hendro', 'uts': 78.0, 'uas': 80.0, 'tugas': 83.0, 'nilaiAkhir': 80.3},
        {'mataPelajaran': 'Bahasa Inggris', 'guru': 'Miss Diana', 'uts': 88.0, 'uas': 89.0, 'tugas': 91.0, 'nilaiAkhir': 89.3},
        {'mataPelajaran': 'Pendidikan Pancasila', 'guru': 'Bu Fitri', 'uts': 85.0, 'uas': 87.0, 'tugas': 89.0, 'nilaiAkhir': 87.0},
        {'mataPelajaran': 'Seni Budaya', 'guru': 'Pak Bambang', 'uts': 81.0, 'uas': 83.0, 'tugas': 85.0, 'nilaiAkhir': 83.0},
        {'mataPelajaran': 'PJOK', 'guru': 'Pak Agus', 'uts': 87.0, 'uas': 89.0, 'tugas': 90.0, 'nilaiAkhir': 88.7},
        {'mataPelajaran': 'Prakarya', 'guru': 'Bu Lina', 'uts': 84.0, 'uas': 86.0, 'tugas': 88.0, 'nilaiAkhir': 86.0},
        {'mataPelajaran': 'Bahasa Jawa', 'guru': 'Pak Sutrisno', 'uts': 76.0, 'uas': 78.0, 'tugas': 80.0, 'nilaiAkhir': 78.0},
      ],
    };

    return allData[semester] ?? [];
  }

  // Card untuk menampilkan nilai mata pelajaran
  Widget _buildNilaiCard(Map<String, dynamic> nilai, bool isFromSearch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan mata pelajaran dan nilai akhir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nilai['mataPelajaran'],
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nilai['guru'],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getGradeColor(nilai['nilaiAkhir']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Nilai Akhir",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        "${nilai['nilaiAkhir']}",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getGradeColor(nilai['nilaiAkhir']),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Detail nilai UTS, UAS, Tugas
            Row(
              children: [
                Expanded(
                  child: _buildScoreDetail("UTS", nilai['uts']),
                ),
                Expanded(
                  child: _buildScoreDetail("UAS", nilai['uas']),
                ),
                Expanded(
                  child: _buildScoreDetail("Tugas", nilai['tugas']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk detail skor (UTS, UAS, Tugas)
  Widget _buildScoreDetail(String label, double score) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  // Fungsi untuk mendapat warna berdasarkan nilai
  Color _getGradeColor(double grade) {
    if (grade >= 90) {
      return const Color(0xFF10B981); // Hijau untuk A
    } else if (grade >= 80) {
      return const Color(0xFF3B82F6); // Biru untuk B
    } else if (grade >= 70) {
      return const Color(0xFFF59E0B); // Kuning untuk C
    } else {
      return const Color(0xFFEF4444); // Merah untuk D
    }
  }
}