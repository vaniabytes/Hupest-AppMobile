import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
// Text Editing Controllers
final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();
final phoneController = TextEditingController();

// Error messages
var emailError = ''.obs;
var passwordError = ''.obs;
var confirmPasswordError = ''.obs;
var phoneError = ''.obs;

// Password visibility
var isPasswordVisible = false.obs;
var isConfirmPasswordVisible = false.obs;

// Form valid state
var isFormValid = false.obs;

@override
void onInit() {
super.onInit();
// Listen to changes to update form validity
everAll([
emailError,
passwordError,
confirmPasswordError,
phoneError,
], (_) => validateForm());
}

void togglePasswordVisibility() {
isPasswordVisible.value = !isPasswordVisible.value;
}

void toggleConfirmPasswordVisibility() {
isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
}

void validateEmail(String value) {
if (value.isEmpty) {
emailError.value = 'Email tidak boleh kosong';
} else if (!GetUtils.isEmail(value)) {
emailError.value = 'Email tidak valid';
} else {
emailError.value = '';
}
}

void validatePassword(String value) {
if (value.isEmpty) {
passwordError.value = 'Password tidak boleh kosong';
} else if (value.length < 6) {
passwordError.value = 'Minimal 6 karakter';
} else {
passwordError.value = '';
}
validateConfirmPassword(confirmPasswordController.text); // Revalidate confirm password
}

void validateConfirmPassword(String value) {
if (value != passwordController.text) {
confirmPasswordError.value = 'Password tidak sama';
} else {
confirmPasswordError.value = '';
}
}

void validatePhone(String value) {
if (value.isEmpty) {
phoneError.value = 'Nomor telepon tidak boleh kosong';
} else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
phoneError.value = 'Nomor tidak valid';
} else {
phoneError.value = '';
}
}

void validateForm() {
isFormValid.value =
emailError.value.isEmpty &&
passwordError.value.isEmpty &&
confirmPasswordError.value.isEmpty &&
phoneError.value.isEmpty &&
emailController.text.isNotEmpty &&
passwordController.text.isNotEmpty &&
confirmPasswordController.text.isNotEmpty &&
phoneController.text.isNotEmpty;
}

void register() {
// Validasi ulang sebelum submit
validateEmail(emailController.text);
validatePassword(passwordController.text);
validateConfirmPassword(confirmPasswordController.text);
validatePhone(phoneController.text);
if (isFormValid.value) {
  // Simulasi pendaftaran berhasil
  Get.snackbar(
    'Sukses',
    'Akun berhasil dibuat!',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green[400],
    colorText: Colors.white,
  );

  // Arahkan langsung ke halaman home
  Get.offAllNamed('/home');
}
}

@override
void onClose() {
emailController.dispose();
passwordController.dispose();
confirmPasswordController.dispose();
phoneController.dispose();
super.onClose();
}
}