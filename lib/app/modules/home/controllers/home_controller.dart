import 'package:get/get.dart';

class HomeController extends GetxController {
final _userName = 'Pengguna'.obs;
String get userName => _userName.value;
  var showSidebar = false.obs;

final _isLoading = false.obs;
final _topStudents = <Map<String, dynamic>>[].obs;

final totalTasks = 10.obs;
final completedTasks = 6.obs;
final averageScore = 85.4.obs;

@override
void onInit() {
super.onInit();
_loadUserData();
_loadTopStudents();
} 
  void toggleSidebar() {
    print("Toggling sidebar: ${showSidebar.value} -> ${!showSidebar.value}");
    showSidebar.value = !showSidebar.value;
  }

Future<void> _loadUserData() async {
_isLoading.value = true;
try {
await Future.delayed(Duration(milliseconds: 500));
_userName.value = 'Jihan';
} catch (e) {
print('Error loading user data: $e');
} finally {
_isLoading.value = false;
}
}

void updateUserName(String name) {
if (name.isEmpty) return;
_userName.value = name;
}

Future<void> _loadTopStudents() async {
_isLoading.value = true;
try {
await Future.delayed(const Duration(seconds: 1));
_topStudents.value = [
{'name': 'Nasywa L.', 'score': '95,00'},
{'name': 'Ahmad R.', 'score': '94,76'},
{'name': 'Dina K.', 'score': '94,32'},
{'name': 'Budi S.', 'score': '93,40'},
{'name': 'Lina M.', 'score': '93,11'},
{'name': 'Eko P.', 'score': '93,06'},
{'name': 'Dewi A.', 'score': '92,89'},
{'name': 'Farah Y.', 'score': '90,98'},
{'name': 'Gita N.', 'score': '90,74'},
{'name': 'Hasan Z.', 'score': '90,23'},
];
} catch (e) {
print('Error loading top students: $e');
} finally {
_isLoading.value = false;
}
}

List<Map<String, dynamic>> get topStudents => _topStudents;
bool get isLoading => _isLoading.value;
}