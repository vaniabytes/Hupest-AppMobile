import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackProgressController extends GetxController {
  // Observable variables untuk statistik umum
  var averageScore = 85.5.obs;
  var totalTasks = 45.obs;
  var completedTasks = 38.obs;

  // Observable untuk progress per mata pelajaran
  var subjectProgress = <Map<String, dynamic>>[].obs;
  
  // Observable untuk statistik bulanan
  var monthlyStats = <String, dynamic>{}.obs;
  
  // Observable untuk achievements/target
  var achievements = <Map<String, dynamic>>[].obs;
  
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProgressData();
  }

  void loadProgressData() {
    isLoading.value = true;
    
    // Simulasi loading data
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Data progress per mata pelajaran
      subjectProgress.value = [
        {
          'name': 'Matematika',
          'icon': Icons.calculate,
          'color': Colors.blue,
          'grade': 88,
          'progress': 0.85,
          'completed': 12,
          'total': 14,
          'status': 'Sangat Baik'
        },
        {
          'name': 'Bahasa Indonesia',
          'icon': Icons.book,
          'color': Colors.green,
          'grade': 92,
          'progress': 0.95,
          'completed': 19,
          'total': 20,
          'status': 'Excellent'
        },
        {
          'name': 'IPA',
          'icon': Icons.science,
          'color': Colors.purple,
          'grade': 79,
          'progress': 0.70,
          'completed': 7,
          'total': 10,
          'status': 'Baik'
        },
        {
          'name': 'Sejarah',
          'icon': Icons.history_edu,
          'color': Colors.orange,
          'grade': 84,
          'progress': 0.80,
          'completed': 8,
          'total': 10,
          'status': 'Baik'
        },
        {
          'name': 'Bahasa Inggris',
          'icon': Icons.language,
          'color': Colors.red,
          'grade': 86,
          'progress': 0.75,
          'completed': 9,
          'total': 12,
          'status': 'Baik'
        },
        {
          'name': 'PKN',
          'icon': Icons.flag,
          'color': Colors.teal,
          'grade': 90,
          'progress': 0.90,
          'completed': 9,
          'total': 10,
          'status': 'Sangat Baik'
        },
      ];

      // Data statistik bulanan
      monthlyStats.value = {
        'submitted': 42,
        'average': 87.2,
        'late': 3,
      };

      // Data achievements/target
      achievements.value = [
        {
          'title': 'Nilai Rata-rata 85+',
          'description': 'Mencapai rata-rata nilai minimal 85',
          'progress': 1.0,
          'achieved': true,
        },
        {
          'title': 'Selesaikan 90% Tugas',
          'description': 'Menyelesaikan minimal 90% dari seluruh tugas',
          'progress': 0.84,
          'achieved': false,
        },
        {
          'title': 'Zero Keterlambatan',
          'description': 'Tidak terlambat mengumpulkan tugas selama sebulan',
          'progress': 0.90,
          'achieved': false,
        },
        {
          'title': 'Peringkat 10 Besar',
          'description': 'Masuk dalam 10 besar ranking kelas',
          'progress': 1.0,
          'achieved': true,
        },
        {
          'title': 'Perfect Attendance',
          'description': 'Kehadiran 100% selama sebulan',
          'progress': 0.95,
          'achieved': false,
        },
      ];

      isLoading.value = false;
    });
  }

  void refreshProgress() {
    loadProgressData();
  }

  // Method untuk mendapatkan overall progress
  double get overallProgress {
    if (totalTasks.value == 0) return 0.0;
    return completedTasks.value / totalTasks.value;
  }

  // Method untuk mendapatkan progress grade
  String getProgressGrade() {
    final progress = overallProgress;
    if (progress >= 0.9) return 'A';
    if (progress >= 0.8) return 'B';
    if (progress >= 0.7) return 'C';
    if (progress >= 0.6) return 'D';
    return 'E';
  }

  // Method untuk mendapatkan warna berdasarkan progress
  Color getProgressColor() {
    final progress = overallProgress;
    if (progress >= 0.9) return Colors.green;
    if (progress >= 0.8) return Colors.blue;
    if (progress >= 0.7) return Colors.orange;
    return Colors.red;
  }

  // Method untuk update progress mata pelajaran tertentu
  void updateSubjectProgress(String subjectName, int completed, int total) {
    final index = subjectProgress.indexWhere((subject) => subject['name'] == subjectName);
    if (index != -1) {
      subjectProgress[index]['completed'] = completed;
      subjectProgress[index]['total'] = total;
      subjectProgress[index]['progress'] = completed / total;
      subjectProgress.refresh();
    }
  }

  // Method untuk menambah tugas yang diselesaikan
  void addCompletedTask() {
    if (completedTasks.value < totalTasks.value) {
      completedTasks.value++;
    }
  }

  // Method untuk update rata-rata nilai
  void updateAverageScore(double newScore) {
    averageScore.value = newScore;
  }

  // Method untuk mendapatkan status berdasarkan progress
  String getStatusFromProgress(double progress) {
    if (progress >= 0.95) return 'Excellent';
    if (progress >= 0.85) return 'Sangat Baik';
    if (progress >= 0.75) return 'Baik';
    if (progress >= 0.65) return 'Cukup';
    return 'Perlu Perbaikan';
  }

  // Method untuk check achievement completion
  void checkAchievements() {
    for (var achievement in achievements) {
      // Logic untuk check masing-masing achievement
      switch (achievement['title']) {
        case 'Nilai Rata-rata 85+':
          achievement['achieved'] = averageScore.value >= 85;
          achievement['progress'] = (averageScore.value / 85).clamp(0.0, 1.0);
          break;
        case 'Selesaikan 90% Tugas':
          final taskProgress = completedTasks.value / totalTasks.value;
          achievement['achieved'] = taskProgress >= 0.9;
          achievement['progress'] = taskProgress;
          break;
        // Add more achievement checks as needed
      }
    }
    achievements.refresh();
  }
}