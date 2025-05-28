import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_navbar_view.dart';
import '../../../widgets/profile_sidebar.dart';
import '../controllers/daftar_tugas_controller.dart';

class DaftarTugasView extends GetView<DaftarTugasController> {
  const DaftarTugasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DaftarTugasController());

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5DD),
      body: SafeArea(
        child: Stack(
          children: [
            // Konten Utama
            Column(
              children: [
                CustomNavbarView(
                  selectedIndex: 2,
                  userName: "Jihan",
                  onTabSelected: (index) {
                    if (index == 0) {
                      Get.toNamed('/daftar-nilai');
                    } else if (index == 1) {
                      Get.toNamed('/home');
                    }
                  },
                  onProfileTap: () => controller.toggleSidebar(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section - Fixed overflow
                        Row(
                          children: [
                            Expanded( // Wrap dengan Expanded
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daftar Tugas",
                                    style: GoogleFonts.inter(
                                      fontSize: 24, // Reduced font size
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF5A8151),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(() => Text(
                                    "${controller.tugasList.length} tugas tersedia",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12), // Add spacing
                            ElevatedButton.icon(
                              onPressed: () => controller.showAddTugasDialog(),
                              icon: const Icon(Icons.add, color: Colors.white, size: 18),
                              label: Text(
                                "Tambah",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14, // Smaller font
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A8151),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12, // Reduced padding
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Filter Tabs
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(() => Row(
                            children: [
                              _buildFilterTab("Semua", 0, controller.selectedFilter.value),
                              _buildFilterTab("Aktif", 1, controller.selectedFilter.value),
                              _buildFilterTab("Selesai", 2, controller.selectedFilter.value),
                            ],
                          )),
                        ),
                        const SizedBox(height: 16),
                        
                        // Task List
                        Expanded(
                          child: Obx(() {
                            final filteredTugas = controller.getFilteredTugas();
                            if (filteredTugas.isEmpty) {
                              return _buildEmptyState();
                            }
                            return ListView.builder(
                              itemCount: filteredTugas.length,
                              itemBuilder: (context, index) {
                                final tugas = filteredTugas[index];
                                return _buildTugasCard(tugas, controller);
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

            // Sidebar + overlay penutup (sama seperti DaftarNilaiView)
            Obx(() {
              if (!controller.isSidebarOpen.value) return const SizedBox.shrink();

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

  Widget _buildFilterTab(String title, int index, int selectedIndex) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.find<DaftarTugasController>().setFilter(index),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5A8151) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTugasCard(Map<String, dynamic> tugas, DaftarTugasController controller) {
    final isCompleted = tugas['isCompleted'] as bool;
    final deadline = DateTime.parse(tugas['deadline']);
    final now = DateTime.now();
    final daysLeft = deadline.difference(now).inDays;

    Color priorityColor;
    switch (tugas['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            width: 4,
            color: isCompleted ? Colors.green : priorityColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => controller.toggleTugasStatus(tugas['id']),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? Colors.green : priorityColor,
                      width: 2,
                    ),
                    color: isCompleted ? Colors.green : Colors.transparent,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tugas['title'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? Colors.grey : const Color(0xFF2D3748),
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2, // Add maxLines to prevent overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (tugas['description'].isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        tugas['description'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    
                    // Tags and deadline - Fixed layout
                    Wrap( // Use Wrap instead of Row to prevent overflow
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tugas['priority'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: priorityColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tugas['subject'] == 'Matematika'
                                ? Colors.blue.withOpacity(0.1)
                                : tugas['subject'] == 'Bahasa Indonesia'
                                    ? Colors.purple.withOpacity(0.1)
                                    : Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tugas['subject'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: tugas['subject'] == 'Matematika'
                                  ? Colors.blue
                                  : tugas['subject'] == 'Bahasa Indonesia'
                                      ? Colors.purple
                                      : Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Deadline - Separate row
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: daysLeft < 0
                              ? Colors.red
                              : daysLeft <= 1
                                  ? Colors.orange
                                  : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded( // Wrap with Expanded
                          child: Text(
                            daysLeft < 0
                                ? "Terlambat"
                                : daysLeft == 0
                                    ? "Hari ini"
                                    : "$daysLeft hari lagi",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: daysLeft < 0
                                  ? Colors.red
                                  : daysLeft <= 1
                                      ? Colors.orange
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      controller.showEditTugasDialog(tugas);
                    } else if (value == 'delete') {
                      controller.deleteTugas(tugas['id']);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 16),
                          const SizedBox(width: 8),
                          Text('Edit', style: GoogleFonts.inter()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 16, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('Hapus', style: GoogleFonts.inter(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(Icons.more_vert, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Belum ada tugas",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tambahkan tugas pertama kamu dengan\nmenekan tombol Tambah di atas",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.showAddTugasDialog(),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              "Tambah Tugas",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A8151),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}