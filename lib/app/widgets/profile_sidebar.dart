import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../app/modules/edit_profile/views/edit_profile_view.dart'; 

class ProfileSidebar extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? userProfileImage;
  final VoidCallback? onClose;

  const ProfileSidebar({
    Key? key,
    this.userName = "Jihan",
    this.userRole = "Siswa Kelas IX",
    this.userProfileImage,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white, // Pastikan background putih bersih
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Profile
              GestureDetector(
                onTap: () {
                  _navigateToEditProfile();
                  if (onClose != null) {
                    onClose!();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 25),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A8151),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Picture with edit indicator
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: ClipOval(
                              child: userProfileImage != null && userProfileImage!.isNotEmpty
                                ? Image.network(
                                    userProfileImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey.shade600,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                            ),
                          ),
                          // Edit indicator
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF5A8151), width: 2),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Color(0xFF5A8151),
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // User Name
                      Text(
                        userName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // User Role with edit text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userRole,
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ketuk untuk edit profil',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Menu Items
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.track_changes_outlined,
                          label: 'Track Progress',
                                                    onTap: () {
                            Get.toNamed('/track-progress');
                            if (onClose != null) onClose!();
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          label: 'Pemberitahuan',
                          onTap: () {
                            Get.toNamed('/pemberitahuan');
                            if (onClose != null) onClose!();
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'Jadwal Pelajaran',
                           onTap: () {
                            Get.toNamed('/jadwal-pelajaran');
                            if (onClose != null) onClose!();
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.how_to_reg_outlined,
                          label: 'Presensi Siswa',
                          onTap: () {
                            Get.toNamed('/absen-siswa');
                            if (onClose != null) onClose!();
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Logout Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildMenuItem(
                          icon: Icons.logout,
                          label: 'Keluar',
                          onTap: () {
                            _showLogoutDialog();
                          },
                          isLogout: true,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: isLogout 
          ? Colors.red.withOpacity(0.15) 
          : Colors.grey.withOpacity(0.15),
        highlightColor: isLogout 
          ? Colors.red.withOpacity(0.08) 
          : Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isLogout ? Colors.red.shade600 : Colors.grey.shade600,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isLogout ? Colors.red.shade600 : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile() {
    try {
      Get.toNamed('/edit-profile');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka halaman edit profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Keluar',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Info',
                'Anda telah keluar dari aplikasi',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Keluar',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}