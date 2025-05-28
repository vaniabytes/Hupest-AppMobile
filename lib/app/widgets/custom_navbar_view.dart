import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavbarView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final String userName;
  final String? userProfileImage;
  final VoidCallback? onProfileTap;

  const CustomNavbarView({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.userName = "Jihan",
    this.userProfileImage,
    this.onProfileTap,
  }) : super(key: key);

  String _getPageTitle() {
    switch (selectedIndex) {
      case 0:
        return "Lihat semua nilai kamu!";
      case 1:
        return "Ada tugas yang belum selesai?";
      case 2:
        return "Yuk selesaikan tugasmu!";
      default:
        return "Ada tugas yang belum selesai?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF5A8151),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: userProfileImage != null && userProfileImage!.isNotEmpty
                            ? Image.network(
                                userProfileImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person, color: Colors.grey.shade600);
                                },
                              )
                            : Icon(Icons.person, color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Halo, $userName",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                _getPageTitle(),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -15),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _buildNavButton(label: 'Daftar Nilai', index: 0)),
                Expanded(child: _buildNavButton(label: 'Dashboard', index: 1)),
                Expanded(child: _buildNavButton(label: 'Daftar Tugas', index: 2)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        print("Nav button tapped: $index - $label");
        // Hanya panggil onTabSelected, biarkan parent yang handle navigasi
        onTabSelected(index);
        
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D5A36) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}