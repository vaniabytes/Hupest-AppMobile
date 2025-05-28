import 'package:get/get.dart';

import '../modules/absen_siswa/bindings/absen_siswa_binding.dart';
import '../modules/absen_siswa/views/absen_siswa_view.dart';
import '../modules/daftar_nilai/bindings/daftar_nilai_binding.dart';
import '../modules/daftar_nilai/views/daftar_nilai_view.dart';
import '../modules/daftar_tugas/bindings/daftar_tugas_binding.dart';
import '../modules/daftar_tugas/views/daftar_tugas_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/jadwal_pelajaran/bindings/jadwal_pelajaran_binding.dart';
import '../modules/jadwal_pelajaran/views/jadwal_pelajaran_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pemberitahuan/bindings/pemberitahuan_binding.dart';
import '../modules/pemberitahuan/views/pemberitahuan_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/track_progress/bindings/track_progress_binding.dart';
import '../modules/track_progress/views/track_progress_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DAFTAR_NILAI,
      page: () => const DaftarNilaiView(),
      binding: DaftarNilaiBinding(),
    ),
    GetPage(
  name: '/daftar-tugas',
  page: () => const DaftarTugasView(),
  binding: DaftarTugasBinding(),
),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL_PELAJARAN,
      page: () => const JadwalPelajaranView(),
      binding: JadwalPelajaranBinding(),
    ),
    GetPage(
      name: _Paths.ABSEN_SISWA,
      page: () => const AbsenSiswaView(),
      binding: AbsenSiswaBinding(),
    ),
    GetPage(
      name: _Paths.PEMBERITAHUAN,
      page: () => const PemberitahuanView(),
      binding: PemberitahuanBinding(),
    ),
    GetPage(
      name: _Paths.TRACK_PROGRESS,
      page: () => const TrackProgressView(),
      binding: TrackProgressBinding(),
    ),
  ];
}
