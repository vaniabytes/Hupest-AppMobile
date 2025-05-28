import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JadwalPelajaranController extends GetxController {
  // Observable variables
  var selectedDay = 'Senin'.obs;
  var isLoading = false.obs;
  var showAddForm = false.obs;
  
  // Days of the week (Senin-Jumat untuk sekolah negeri)
  final List<String> days = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'
  ];
  
  // Time slots regular (Senin-Kamis: 9 jam pelajaran, pulang 14:30)
  final List<String> timeSlots = [
    '07:00 - 07:40', // Jam ke-1
    '07:40 - 08:20', // Jam ke-2
    '08:20 - 09:00', // Jam ke-3
    '09:15 - 09:55', // Jam ke-4 (setelah istirahat)
    '09:55 - 10:35', // Jam ke-5
    '10:35 - 11:15', // Jam ke-6
    '11:30 - 12:10', // Jam ke-7 (setelah istirahat)
    '12:10 - 12:50', // Jam ke-8
    '12:50 - 14:30', // Jam ke-9 (pulang 14:30)
  ];
  
  // Time slots untuk Jumat (9 jam pelajaran tapi pulang jam 11:30 - durasi lebih pendek)
  final List<String> fridayTimeSlots = [
    '07:00 - 07:25', // Jam ke-1 (25 menit)
    '07:25 - 07:50', // Jam ke-2 (25 menit)
    '07:50 - 08:15', // Jam ke-3 (25 menit)
    '08:15 - 08:40', // Jam ke-4 (25 menit)
    '08:40 - 09:05', // Jam ke-5 (25 menit)
    '09:20 - 09:45', // Jam ke-6 (25 menit, setelah istirahat)
    '09:45 - 10:10', // Jam ke-7 (25 menit)
    '10:10 - 10:35', // Jam ke-8 (25 menit)
    '10:35 - 11:00', // Jam ke-9 (25 menit)
  ];
  
  // Extra time slots untuk kegiatan ekstrakurikuler (1.5 jam)
  final List<String> extraTimeSlots = [
    '14:30 - 16:00', // Ekstra 1 (setelah pulang sekolah Senin-Kamis)
    '16:00 - 17:30', // Ekstra 2
    '11:30 - 13:00', // Ekstra Jumat (setelah pulang sekolah Jumat)
    '13:00 - 14:30', // Ekstra Jumat 2
  ];
  
  // Available subjects
  final List<String> subjects = [
    'Matematika',
    'Bahasa Indonesia', 
    'Bahasa Inggris',
    'IPA',
    'IPS',
    'PKN',
    'Agama',
    'Seni Budaya',
    'Prakarya',
    'PJOK',
    'Bahasa Daerah',
    'TIK',
    'BK',
  ];
  
  // Ekstrakurikuler subjects
  final List<String> extraSubjects = [
    'Pramuka',
    'PMR',
    'Basket',
    'Futsal',
    'Voli',
    'Badminton',
    'Tari',
    'Musik',
    'Teater',
    'Jurnalistik',
    'Robotika',
    'English Club',
    'Math Club',
    'Science Club',
  ];
  
  // Colors for subjects
  final List<int> subjectColors = [
    0xFF4A90E2, // Blue
    0xFF27AE60, // Green
    0xFF9B59B6, // Purple
    0xFFE74C3C, // Red
    0xFFE67E22, // Orange
    0xFF1ABC9C, // Teal
    0xFFFF6B6B, // Light Red
    0xFF4ECDC4, // Light Teal
    0xFFFFE66D, // Yellow
    0xFF95E1D3, // Mint
    0xFFC7CEEA, // Lavender
    0xFFFF8B94, // Pink
    0xFFA8E6CF, // Light Green
    0xFFFFD93D, // Gold
  ];
  
  // User's schedule data
  var userSchedule = <String, List<Map<String, dynamic>>>{
    'Senin': <Map<String, dynamic>>[],
    'Selasa': <Map<String, dynamic>>[],
    'Rabu': <Map<String, dynamic>>[],
    'Kamis': <Map<String, dynamic>>[],
    'Jumat': <Map<String, dynamic>>[],
  }.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSampleData();
  }
  
  void loadSampleData() {
    // Sample data untuk beberapa hari agar "Jadwal Hari Ini" tidak selalu 0
    String today = _getTodayName();
    
    // Sample data untuk Senin
    userSchedule['Senin'] = [
      {
        'id': '1',
        'timeSlot': '07:00 - 07:40',
        'subject': 'Matematika',
        'teacher': 'Pak Budi',
        'room': 'Ruang 12A',
        'color': 0xFF4A90E2,
        'isExtra': false,
      },
      {
        'id': '2', 
        'timeSlot': '07:40 - 08:20',
        'subject': 'Matematika',
        'teacher': 'Pak Budi',
        'room': 'Ruang 12A',
        'color': 0xFF4A90E2,
        'isExtra': false,
      },
      {
        'id': '3',
        'timeSlot': '09:15 - 09:55',
        'subject': 'Bahasa Indonesia',
        'teacher': 'Bu Sari',
        'room': 'Ruang 8B',
        'color': 0xFF27AE60,
        'isExtra': false,
      },
    ];
    
    // Sample data untuk Selasa
    userSchedule['Selasa'] = [
      {
        'id': '4',
        'timeSlot': '07:00 - 07:40',
        'subject': 'IPA',
        'teacher': 'Bu Dina',
        'room': 'Lab IPA',
        'color': 0xFFE74C3C,
        'isExtra': false,
      },
      {
        'id': '5',
        'timeSlot': '07:40 - 08:20',
        'subject': 'Bahasa Inggris',
        'teacher': 'Mr. John',
        'room': 'Ruang 10A',
        'color': 0xFF9B59B6,
        'isExtra': false,
      },
    ];
    
    // Sample data untuk Rabu
    userSchedule['Rabu'] = [
      {
        'id': '6',
        'timeSlot': '07:00 - 07:40',
        'subject': 'IPS',
        'teacher': 'Bu Rina',
        'room': 'Ruang 9B',
        'color': 0xFFE67E22,
        'isExtra': false,
      },
    ];
    
    // Sample data untuk Kamis
    userSchedule['Kamis'] = [
      {
        'id': '7',
        'timeSlot': '07:00 - 07:40',
        'subject': 'PKN',
        'teacher': 'Pak Ahmad',
        'room': 'Ruang 11A',
        'color': 0xFF1ABC9C,
        'isExtra': false,
      },
      {
        'id': '8',
        'timeSlot': '07:40 - 08:20',
        'subject': 'Agama',
        'teacher': 'Bu Fatimah',
        'room': 'Ruang 7C',
        'color': 0xFFFF6B6B,
        'isExtra': false,
      },
      {
        'id': '9',
        'timeSlot': '08:20 - 09:00',
        'subject': 'PJOK',
        'teacher': 'Pak Joko',
        'room': 'Lapangan',
        'color': 0xFF4ECDC4,
        'isExtra': false,
      },
    ];
    
    // Sample data untuk Jumat (dengan jadwal yang lebih padat)
    userSchedule['Jumat'] = [
      {
        'id': '10',
        'timeSlot': '07:00 - 07:25',
        'subject': 'Agama',
        'teacher': 'Bu Fatimah',
        'room': 'Ruang 7C',
        'color': 0xFFFF6B6B,
        'isExtra': false,
      },
      {
        'id': '11',
        'timeSlot': '07:25 - 07:50',
        'subject': 'Bahasa Indonesia',
        'teacher': 'Bu Sari',
        'room': 'Ruang 8B',
        'color': 0xFF27AE60,
        'isExtra': false,
      },
      {
        'id': '12',
        'timeSlot': '07:50 - 08:15',
        'subject': 'Matematika',
        'teacher': 'Pak Budi',
        'room': 'Ruang 12A',
        'color': 0xFF4A90E2,
        'isExtra': false,
      },
      {
        'id': '13',
        'timeSlot': '08:15 - 08:40',
        'subject': 'IPA',
        'teacher': 'Bu Dina',
        'room': 'Lab IPA',
        'color': 0xFFE74C3C,
        'isExtra': false,
      },
    ];
  }
  
  // Get available time slots based on selected day
  List<String> getAvailableTimeSlots({bool isExtra = false}) {
    if (isExtra) {
      return extraTimeSlots;
    }
    
    if (selectedDay.value == 'Jumat') {
      return fridayTimeSlots;
    }
    
    return timeSlots;
  }
  
  // Get available subjects based on type
  List<String> getAvailableSubjects({bool isExtra = false}) {
    return isExtra ? extraSubjects : subjects;
  }
  
  void changeDay(String day) {
    selectedDay.value = day;
    update(); // Notify GetBuilder
  }
  
  void toggleAddForm() {
    showAddForm.value = !showAddForm.value;
    update();
  }
  
  void addScheduleItem({
    required String timeSlot,
    required String subject,
    required String teacher,
    required String room,
    bool isExtra = false,
  }) {
    // Get color based on subject type
    List<String> subjectList = isExtra ? extraSubjects : subjects;
    int colorIndex = subjectList.indexOf(subject);
    if (colorIndex == -1) colorIndex = 0;
    
    final newItem = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'timeSlot': timeSlot,
      'subject': subject,
      'teacher': teacher,
      'room': room,
      'color': subjectColors[colorIndex % subjectColors.length],
      'isExtra': isExtra,
    };
    
    if (userSchedule[selectedDay.value] == null) {
      userSchedule[selectedDay.value] = [];
    }
    
    userSchedule[selectedDay.value]!.add(newItem);
    userSchedule.refresh();
    showAddForm.value = false;
    update(); // Important: notify GetBuilder
    
    Get.snackbar(
      'Berhasil',
      'Jadwal berhasil ditambahkan',
      backgroundColor: const Color(0xFF5A8151),
      colorText: Colors.white,
    );
  }
  
  void deleteScheduleItem(String id) {
    userSchedule[selectedDay.value]?.removeWhere((item) => item['id'] == id);
    userSchedule.refresh();
    update(); // Important: notify GetBuilder
    
    Get.snackbar(
      'Berhasil',
      'Jadwal berhasil dihapus',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  void editScheduleItem({
    required String id,
    required String timeSlot,
    required String subject,
    required String teacher,
    required String room,
    bool isExtra = false,
  }) {
    final index = userSchedule[selectedDay.value]?.indexWhere((item) => item['id'] == id) ?? -1;
    
    if (index != -1) {
      // Get color based on subject type
      List<String> subjectList = isExtra ? extraSubjects : subjects;
      int colorIndex = subjectList.indexOf(subject);
      if (colorIndex == -1) colorIndex = 0;
      
      userSchedule[selectedDay.value]?[index] = {
        'id': id,
        'timeSlot': timeSlot,
        'subject': subject,
        'teacher': teacher,
        'room': room,
        'color': subjectColors[colorIndex % subjectColors.length],
        'isExtra': isExtra,
      };
      userSchedule.refresh();
      update(); // Important: notify GetBuilder
      
      Get.snackbar(
        'Berhasil',
        'Jadwal berhasil diubah',
        backgroundColor: const Color(0xFF5A8151),
        colorText: Colors.white,
      );
    }
  }
  
  List<Map<String, dynamic>> getCurrentDaySchedule() {
    List<Map<String, dynamic>> schedule = userSchedule[selectedDay.value] ?? [];
    
    // Sort by time slot
    schedule.sort((a, b) {
      String timeA = a['timeSlot'].toString().split(' - ')[0];
      String timeB = b['timeSlot'].toString().split(' - ')[0];
      return timeA.compareTo(timeB);
    });
    
    return schedule;
  }
  
  String getTodayScheduleCount() {
    final today = _getTodayName();
    final count = userSchedule[today]?.length ?? 0;
    return count.toString();
  }
  
  String _getTodayName() {
    final weekday = DateTime.now().weekday;
    switch (weekday) {
      case 1: return 'Senin';
      case 2: return 'Selasa';
      case 3: return 'Rabu';
      case 4: return 'Kamis';
      case 5: return 'Jumat';
      case 6: return 'Sabtu'; // Untuk jaga-jaga
      case 7: return 'Minggu'; // Untuk jaga-jaga
      default: return 'Senin';
    }
  }
  
  // Get total jam pelajaran - semua hari tetap 9 jam
  int getTotalClassHours() {
    // Semua hari tetap 9 jam pelajaran
    // Jumat hanya durasinya yang lebih pendek (25 menit vs 40 menit)
    return 9;
  }
}