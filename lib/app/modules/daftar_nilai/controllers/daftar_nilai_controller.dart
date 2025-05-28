import 'package:get/get.dart';

class DaftarNilaiController extends GetxController {
  // Observable variables
  var showSidebar = false.obs;
  var isLoading = true.obs;
  var selectedSemester = 'Semester 1'.obs;
  var searchQuery = ''.obs;
  
  // Data lists
  var nilaiList = <Map<String, dynamic>>[].obs;
  var filteredNilaiList = <Map<String, dynamic>>[].obs;
  
  // Semester options
final semesterList = [
  "Semua Semester",
  "Semester 1 (Kelas VII)", 
  "Semester 2 (Kelas VII)",
  "Semester 3 (Kelas VIII)", 
  "Semester 4 (Kelas VIII)",
  "Semester 5 (Kelas IX)", 
  "Semester 6 (Kelas IX)"
];

  // Computed properties
  double get averageScore {
    if (filteredNilaiList.isEmpty) return 0.0;
    double total = filteredNilaiList.fold(0.0, (sum, item) => sum + item['nilaiAkhir']);
    return total / filteredNilaiList.length;
  }

  @override
  void onInit() {
    super.onInit();
    loadNilaiData();
  }

  void toggleSidebar() {
    showSidebar.value = !showSidebar.value;
  }

  void changeSemester(String? semester) {
    if (semester != null) {
      selectedSemester.value = semester;
      loadNilaiData();
    }
  }

  void filterNilai(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    if (searchQuery.value.isEmpty) {
      filteredNilaiList.value = List.from(nilaiList);
    } else {
      filteredNilaiList.value = nilaiList.where((nilai) {
        return nilai['mataPelajaran']
            .toString()
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void loadNilaiData() {
    isLoading.value = true;
    
    // Simulasi loading data (dalam implementasi nyata, ini akan mengambil data dari API)
    Future.delayed(const Duration(seconds: 1), () {
      nilaiList.value = _generateSampleData();
      applyFilters();
      isLoading.value = false;
    });
  }

  // Sample data generator (replace with actual API call)
  List<Map<String, dynamic>> _generateSampleData() {
    // Data sample untuk semester yang dipilih
    final semesterData = {
      'Semester 1': [
        {
          'mataPelajaran': 'Matematika',
          'guru': 'Dr. Ahmad Sukamto',
          'uts': 85.0,
          'uas': 88.0,
          'tugas': 90.0,
          'nilaiAkhir': 87.5,
          'semester': 'Semester 1',
        },
        {
          'mataPelajaran': 'Bahasa Indonesia',
          'guru': 'Siti Nurhaliza, S.Pd',
          'uts': 78.0,
          'uas': 82.0,
          'tugas': 85.0,
          'nilaiAkhir': 81.5,
          'semester': 'Semester 1',
        },
        {
          'mataPelajaran': 'Bahasa Inggris',
          'guru': 'John Smith, M.A',
          'uts': 92.0,
          'uas': 90.0,
          'tugas': 88.0,
          'nilaiAkhir': 90.0,
          'semester': 'Semester 1',
        },
        {
          'mataPelajaran': 'Fisika',
          'guru': 'Prof. Bambang Hermanto',
          'uts': 75.0,
          'uas': 80.0,
          'tugas': 78.0,
          'nilaiAkhir': 77.5,
          'semester': 'Semester 1',
        },
        {
          'mataPelajaran': 'Kimia',
          'guru': 'Dr. Wati Suryani',
          'uts': 88.0,
          'uas': 85.0,
          'tugas': 92.0,
          'nilaiAkhir': 88.5,
          'semester': 'Semester 1',
        },
        {
          'mataPelajaran': 'Biologi',
          'guru': 'Drs. Hadi Pranoto',
          'uts': 83.0,
          'uas': 87.0,
          'tugas': 85.0,
          'nilaiAkhir': 85.0,
          'semester': 'Semester 1',
        },
      ],
      'Semester 2': [
        {
          'mataPelajaran': 'Matematika',
          'guru': 'Dr. Ahmad Sukamto',
          'uts': 90.0,
          'uas': 92.0,
          'tugas': 88.0,
          'nilaiAkhir': 90.0,
          'semester': 'Semester 2',
        },
        {
          'mataPelajaran': 'Bahasa Indonesia',
          'guru': 'Siti Nurhaliza, S.Pd',
          'uts': 82.0,
          'uas': 85.0,
          'tugas': 87.0,
          'nilaiAkhir': 84.5,
          'semester': 'Semester 2',
        },
        {
          'mataPelajaran': 'Sejarah',
          'guru': 'Drs. Agus Salim',
          'uts': 78.0,
          'uas': 80.0,
          'tugas': 82.0,
          'nilaiAkhir': 80.0,
          'semester': 'Semester 2',
        },
        {
          'mataPelajaran': 'Geografi',
          'guru': 'Rina Sari, S.Pd',
          'uts': 85.0,
          'uas': 83.0,
          'tugas': 88.0,
          'nilaiAkhir': 85.5,
          'semester': 'Semester 2',
        },
      ],
    };

    return semesterData[selectedSemester.value] ?? [];
  }

  void refreshData() {
    loadNilaiData();
  }

  // Method untuk mendapatkan detail nilai berdasarkan mata pelajaran
  Map<String, dynamic>? getNilaiDetail(String mataPelajaran) {
    try {
      return filteredNilaiList.firstWhere(
        (nilai) => nilai['mataPelajaran'] == mataPelajaran,
      );
    } catch (e) {
      return null;
    }
  }

  // Method untuk mendapatkan statistik nilai
  Map<String, dynamic> getStatistik() {
    if (filteredNilaiList.isEmpty) {
      return {
        'total': 0,
        'rata_rata': 0.0,
        'tertinggi': 0.0,
        'terendah': 0.0,
        'lulus': 0,
        'tidak_lulus': 0,
      };
    }

    List<double> scores = filteredNilaiList.map((e) => e['nilaiAkhir'] as double).toList();
    scores.sort();

    int lulus = filteredNilaiList.where((nilai) => nilai['nilaiAkhir'] >= 75).length;
    int tidakLulus = filteredNilaiList.length - lulus;

    return {
      'total': filteredNilaiList.length,
      'rata_rata': averageScore,
      'tertinggi': scores.last,
      'terendah': scores.first,
      'lulus': lulus,
      'tidak_lulus': tidakLulus,
    };
  }

  @override
  void onClose() {
    super.onClose();
  }
}