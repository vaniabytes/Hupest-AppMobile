import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PemberitahuanController extends GetxController {
  // Filter yang dipilih
  String selectedFilter = 'Semua';
  
  // List pemberitahuan (sample data)
  List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Pengumuman Libur Sekolah',
      'message': 'Sekolah akan libur pada tanggal 15-16 Juni 2024 dalam rangka memperingati Hari Raya Idul Adha. Kegiatan belajar mengajar akan dilanjutkan pada hari Senin, 17 Juni 2024.',
      'type': 'Pengumuman',
      'sender': 'Kepala Sekolah',
      'time': '2 jam yang lalu',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'title': 'Tugas Matematika Kelas 10',
      'message': 'Silahkan mengerjakan soal-soal pada buku paket halaman 45-47. Tugas dikumpulkan paling lambat hari Kamis, 13 Juni 2024.',
      'type': 'Tugas',
      'sender': 'Bu Sari - Guru Matematika',
      'time': '5 jam yang lalu',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'id': '3',
      'title': 'Perubahan Jadwal Ujian',
      'message': 'PENTING: Ujian Bahasa Indonesia yang seharusnya dilaksanakan pada hari Rabu, 12 Juni 2024, dipindahkan ke hari Jumat, 14 Juni 2024 pada jam yang sama.',
      'type': 'Penting',
      'sender': 'Wakil Kepala Sekolah',
      'time': '1 hari yang lalu',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '4',
      'title': 'Rapat Orang Tua Siswa',
      'message': 'Mengundang seluruh orang tua siswa untuk menghadiri rapat yang akan dilaksanakan pada hari Sabtu, 15 Juni 2024 pukul 09.00 WIB di Aula Sekolah.',
      'type': 'Pengumuman',
      'sender': 'Komite Sekolah',
      'time': '2 hari yang lalu',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '5',
      'title': 'Pengumpulan Essay Bahasa Inggris',
      'message': 'Reminder: Essay dengan tema "My Future Dreams" harus dikumpulkan hari ini sebelum jam 15.00. Jangan lupa untuk menyertakan nama dan kelas.',
      'type': 'Tugas',
      'sender': 'Mr. John - English Teacher',
      'time': '3 hari yang lalu',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi jika diperlukan
  }

  // Mengubah filter
  void changeFilter(String filter) {
    selectedFilter = filter;
    update();
  }

  // Mendapatkan total notifikasi
  int getTotalNotifications() {
    return notifications.length;
  }

  // Mendapatkan jumlah notifikasi belum dibaca
  int getUnreadCount() {
    return notifications.where((notification) => !notification['isRead']).length;
  }

  // Mendapatkan notifikasi berdasarkan filter
  List<Map<String, dynamic>> getFilteredNotifications() {
    List<Map<String, dynamic>> filtered = [];
    
    switch (selectedFilter) {
      case 'Semua':
        filtered = notifications;
        break;
      case 'Belum Dibaca':
        filtered = notifications.where((notification) => !notification['isRead']).toList();
        break;
      case 'Penting':
        filtered = notifications.where((notification) => notification['type'] == 'Penting').toList();
        break;
      case 'Tugas':
        filtered = notifications.where((notification) => notification['type'] == 'Tugas').toList();
        break;
      case 'Pengumuman':
        filtered = notifications.where((notification) => notification['type'] == 'Pengumuman').toList();
        break;
      default:
        filtered = notifications;
    }
    
    // Urutkan berdasarkan timestamp (terbaru di atas)
    filtered.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    
    return filtered;
  }

  // Menandai notifikasi sebagai sudah dibaca
  void markAsRead(String id) {
    final index = notifications.indexWhere((notification) => notification['id'] == id);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      update();
    }
  }

  // Toggle status baca/belum baca
  void toggleReadStatus(String id) {
    final index = notifications.indexWhere((notification) => notification['id'] == id);
    if (index != -1) {
      notifications[index]['isRead'] = !notifications[index]['isRead'];
      update();
    }
  }

  // Menandai semua notifikasi sebagai sudah dibaca
  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    update();
  }

  // Menambah notifikasi baru
  void addNotification({
    required String title,
    required String message,
    required String type,
    String? sender,
  }) {
    final newNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'message': message,
      'type': type,
      'sender': sender ?? '',
      'time': 'Baru saja',
      'isRead': false,
      'timestamp': DateTime.now(),
    };
    
    notifications.insert(0, newNotification);
    update();
    
    Get.snackbar(
      'Berhasil',
      'Pemberitahuan berhasil ditambahkan',
      backgroundColor: const Color(0xFF5A8151),
      colorText: Colors.white,
    );
  }

  // Menghapus notifikasi
  void deleteNotification(String id) {
    notifications.removeWhere((notification) => notification['id'] == id);
    update();
    
    Get.snackbar(
      'Berhasil',
      'Pemberitahuan berhasil dihapus',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Mendapatkan notifikasi berdasarkan ID
  Map<String, dynamic>? getNotificationById(String id) {
    try {
      return notifications.firstWhere((notification) => notification['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Mendapatkan ringkasan notifikasi untuk dashboard
  Map<String, int> getNotificationSummary() {
    return {
      'total': notifications.length,
      'unread': getUnreadCount(),
      'important': notifications.where((n) => n['type'] == 'Penting').length,
      'tasks': notifications.where((n) => n['type'] == 'Tugas').length,
      'announcements': notifications.where((n) => n['type'] == 'Pengumuman').length,
    };
  }

  // Format waktu relatif
  String getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    }
  }

  // Update waktu relatif untuk semua notifikasi
  void updateRelativeTimes() {
    for (var notification in notifications) {
      notification['time'] = getRelativeTime(notification['timestamp']);
    }
    update();
  }
}