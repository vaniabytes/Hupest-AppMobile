import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  
  var isLoading = false.obs;
  var selectedGender = 'Laki-laki'.obs;
  var selectedClass = 'IX A'.obs;
  
  final List<String> genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> classOptions = ['IX A', 'IX B', 'IX C', 'IX D', 'IX E'];

  @override
  void onInit() {
    super.onInit();
    // Initialize with current user data
    loadUserData();
  }

  void loadUserData() {
    // Simulate loading current user data
    nameController.text = "Jihan Aulia";
    emailController.text = "jihan.aulia@student.sch.id";
    phoneController.text = "081234567890";
    addressController.text = "Jl. Merdeka No. 123, Jakarta";
    parentNameController.text = "Budi Santoso";
    parentPhoneController.text = "081987654321";
    selectedGender.value = "Perempuan";
    selectedClass.value = "IX A";
  }

  void saveProfile() async {
    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Show success message
    Get.snackbar(
      'Berhasil',
      'Profil berhasil diperbarui',
      backgroundColor: const Color(0xFF5A8151),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    parentNameController.dispose();
    parentPhoneController.dispose();
    super.onClose();
  }
}