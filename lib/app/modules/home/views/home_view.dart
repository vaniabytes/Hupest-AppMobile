import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../../../widgets/custom_navbar_view.dart';
import 'package:hupest_app/app/widgets/profile_sidebar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5DD),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Custom Navbar di atas
                Obx(() => CustomNavbarView(
                  selectedIndex: 1, // Dashboard
                  userName: controller.userName,
                  onTabSelected: (index) {
                    if (index == 0) {
                      Get.toNamed('/daftar-nilai');
                    } else if (index == 2) {
                      Get.toNamed('/daftar-tugas');
                    }
                    // Index 1 adalah halaman saat ini (Dashboard/Home)
                  },
                  onProfileTap: () {
                    print("Profile tapped!"); // Debug
                    controller.toggleSidebar(); // Panggil method di controller
                  },
                )),

                // Konten
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Statistik Card
                      Obx(() {
                        final double progress = controller.totalTasks.value == 0
                            ? 0
                            : controller.completedTasks.value / controller.totalTasks.value;

                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5A8151), Color(0xFF5A8151)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Statistik Prestasi",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Rata-rata nilai
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nilai Rata-rata",
                                        style: GoogleFonts.inter(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${controller.averageScore.value.toStringAsFixed(1)}",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Progress Tugas",
                                        style: GoogleFonts.inter(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${(progress * 100).toInt()}%",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Progress bar
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    color: Colors.white,
                                    minHeight: 6,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${controller.completedTasks.value} dari ${controller.totalTasks.value} tugas selesai",
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 25),

                      // Quick Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickStatCard(
                              icon: Icons.school,
                              title: "Mata Pelajaran",
                              value: "12",
                              color: const Color(0xFF4A90E2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildQuickStatCard(
                              icon: Icons.assignment,
                              title: "Tugas Aktif",
                              value: "${controller.totalTasks.value - controller.completedTasks.value}",
                              color: const Color(0xFFE67E22),
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Jadwal Hari Ini
                      Text(
                        "Jadwal Hari Ini",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildScheduleItem("08:00 - 09:30", "Matematika", "Ruang 12A", Colors.blue),
                            _buildScheduleItem("09:45 - 11:15", "Bahasa Indonesia", "Ruang 8B", Colors.green),
                            _buildScheduleItem("13:00 - 14:30", "IPA", "Lab IPA", Colors.purple),
                            _buildScheduleItem("14:45 - 16:15", "Sejarah", "Ruang 5C", Colors.orange),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Ranking
                      Text(
                        "Rank 10 Nilai Tertinggi",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Obx(() => SizedBox(
                            height: 120,
                            child: controller.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.topStudents.length,
                                    itemBuilder: (context, index) {
                                      final student = controller.topStudents[index];
                                      return Container(
                                        width: 90,
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.grey[400],
                                                      size: 40,
                                                    ),
                                                  ),
                                                ),
                                                if (index < 3)
                                                  Positioned(
                                                    top: -5,
                                                    right: -5,
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: index == 0 ? Colors.amber : 
                                                               index == 1 ? Colors.grey[400] : Colors.brown,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${index + 1}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              student['name'] ?? '',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              student['score'] ?? '',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          )),
                      const SizedBox(height: 25),

                      // Pengumuman Terbaru
                      Text(
                        "Pengumuman Terbaru",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildAnnouncementItem(
                              "Ujian Tengah Semester",
                              "Ujian akan dilaksanakan tanggal 15-20 Mei 2025",
                              "2 hari lalu",
                              Icons.announcement,
                              Colors.red,
                            ),
                            _buildAnnouncementItem(
                              "Libur Hari Raya",
                              "Sekolah libur tanggal 25-30 Mei 2025",
                              "1 minggu lalu",
                              Icons.event,
                              Colors.green,
                            ),
                            _buildAnnouncementItem(
                              "Kompetisi Matematika",
                              "Pendaftaran dibuka hingga 28 Mei 2025",
                              "3 hari lalu",
                              Icons.emoji_events,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
            
            // Backdrop overlay
            Obx(() => controller.showSidebar.value
                ? GestureDetector(
                    onTap: () {
                      controller.toggleSidebar();
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : const SizedBox()),
            
            // Sidebar
            Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: controller.showSidebar.value ? 0 : -320,
              top: 0,
              bottom: 0,
              child: controller.showSidebar.value
                  ? ProfileSidebar(
                      userName: controller.userName,
                      userRole: "Siswa Kelas IX",
                      onClose: () {
                        controller.toggleSidebar();
                      },
                    )
                  : const SizedBox(),
            )),
          ],
        ),
      ),
    );
  }

  // Helper methods untuk build components
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Pagi";
    if (hour < 15) return "Siang";
    if (hour < 18) return "Sore";
    return "Malam";
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String subject, String room, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$time • $room",
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(String title, String description, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}