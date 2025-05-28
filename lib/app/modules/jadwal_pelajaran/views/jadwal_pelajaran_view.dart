import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/jadwal_pelajaran_controller.dart';

class JadwalPelajaranView extends GetView<JadwalPelajaranController> {
  const JadwalPelajaranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A8151),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Jadwal Pelajaran',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header dengan statistik
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF5A8151),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              GetBuilder<JadwalPelajaranController>(
                                builder: (controller) => Text(
                                  controller.getTodayScheduleCount(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Jadwal Hari Ini',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              GetBuilder<JadwalPelajaranController>(
                                builder: (controller) => Text(
                                  controller.getTotalClassHours().toString(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Jam Pelajaran',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Days selector
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<JadwalPelajaranController>(
              builder: (controller) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.days.length,
                itemBuilder: (context, index) {
                  final day = controller.days[index];
                  final isSelected = controller.selectedDay.value == day;
                  
                  return GestureDetector(
                    onTap: () => controller.changeDay(day),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF5A8151) : const Color(0xFF8FBC8F),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Schedule list
          Expanded(
            child: GetBuilder<JadwalPelajaranController>(
              builder: (controller) {
                final schedule = controller.getCurrentDaySchedule();
                
                if (schedule.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada jadwal',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan jadwal pelajaran untuk hari ${controller.selectedDay.value}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _showAddScheduleDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Jadwal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A8151),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final item = schedule[index];
                    return _buildScheduleCard(item, context);
                  },
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        backgroundColor: const Color(0xFF5A8151),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildScheduleCard(Map<String, dynamic> item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => _showEditScheduleDialog(item, context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: Color(item['color']),
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(item['color']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['timeSlot'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(item['color']),
                            ),
                          ),
                        ),
                        if (item['isExtra'] == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'EKSKUL',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['subject'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (item['teacher'] != null && item['teacher'].isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['teacher'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    if (item['room'] != null && item['room'].isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['room'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditScheduleDialog(item, context);
                  } else if (value == 'delete') {
                    _showDeleteDialog(item['id'], context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddScheduleDialog(BuildContext context) {
    String selectedTimeSlot = '';
    String selectedSubject = '';
    String teacher = '';
    String room = '';
    bool isExtra = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Set initial values inside StatefulBuilder to ensure proper updates
          List<String> availableTimeSlots = controller.getAvailableTimeSlots(isExtra: isExtra);
          List<String> availableSubjects = controller.getAvailableSubjects(isExtra: isExtra);
          
          // Initialize selected values if empty
          if (selectedTimeSlot.isEmpty && availableTimeSlots.isNotEmpty) {
            selectedTimeSlot = availableTimeSlots.first;
          }
          if (selectedSubject.isEmpty && availableSubjects.isNotEmpty) {
            selectedSubject = availableSubjects.first;
          }
          
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Tambah Jadwal',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Toggle untuk ekstrakurikuler
                  Row(
                    children: [
                      Checkbox(
                        value: isExtra,
                        onChanged: (value) {
                          setState(() {
                            isExtra = value ?? false;
                            // Reset selections when toggling
                            selectedTimeSlot = '';
                            selectedSubject = '';
                          });
                        },
                        activeColor: const Color(0xFF5A8151),
                      ),
                      Text(
                        'Ekstrakurikuler',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Time Slot Dropdown
                  DropdownButtonFormField<String>(
                    value: availableTimeSlots.contains(selectedTimeSlot) ? selectedTimeSlot : null,
                    decoration: InputDecoration(
                      labelText: 'Jam Pelajaran',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: availableTimeSlots.map((time) {
                      return DropdownMenuItem(value: time, child: Text(time));
                    }).toList(),
                    onChanged: (value) => selectedTimeSlot = value ?? '',
                  ),
                  const SizedBox(height: 12),
                  
                  // Subject Dropdown
                  DropdownButtonFormField<String>(
                    value: availableSubjects.contains(selectedSubject) ? selectedSubject : null,
                    decoration: InputDecoration(
                      labelText: isExtra ? 'Ekstrakurikuler' : 'Mata Pelajaran',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: availableSubjects.map((subject) {
                      return DropdownMenuItem(value: subject, child: Text(subject));
                    }).toList(),
                    onChanged: (value) => selectedSubject = value ?? '',
                  ),
                  const SizedBox(height: 12),
                  
                  // Teacher TextField
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: isExtra ? 'Pembina/Pelatih (opsional)' : 'Nama Guru (opsional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) => teacher = value,
                  ),
                  const SizedBox(height: 12),
                  
                  // Room TextField
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: isExtra ? 'Tempat Kegiatan (opsional)' : 'Ruangan (opsional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) => room = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedTimeSlot.isNotEmpty && selectedSubject.isNotEmpty) {
                    controller.addScheduleItem(
                      timeSlot: selectedTimeSlot,
                      subject: selectedSubject,
                      teacher: teacher,
                      room: room,
                      isExtra: isExtra,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar(
                      'Error',
                      'Mohon pilih jam dan mata pelajaran',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A8151),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _showEditScheduleDialog(Map<String, dynamic> item, BuildContext context) {
    String selectedTimeSlot = item['timeSlot'];
    String selectedSubject = item['subject'];
    String teacher = item['teacher'] ?? '';
    String room = item['room'] ?? '';
    bool isExtra = item['isExtra'] ?? false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          List<String> availableTimeSlots = controller.getAvailableTimeSlots(isExtra: isExtra);
          List<String> availableSubjects = controller.getAvailableSubjects(isExtra: isExtra);
          
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Edit Jadwal',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Toggle untuk ekstrakurikuler
                  Row(
                    children: [
                      Checkbox(
                        value: isExtra,
                        onChanged: (value) {
                          setState(() {
                            isExtra = value ?? false;
                            // Update available options and reset if needed
                            List<String> newTimeSlots = controller.getAvailableTimeSlots(isExtra: isExtra);
                            List<String> newSubjects = controller.getAvailableSubjects(isExtra: isExtra);
                            
                            if (!newTimeSlots.contains(selectedTimeSlot) && newTimeSlots.isNotEmpty) {
                              selectedTimeSlot = newTimeSlots.first;
                            }
                            if (!newSubjects.contains(selectedSubject) && newSubjects.isNotEmpty) {
                              selectedSubject = newSubjects.first;
                            }
                          });
                        },
                        activeColor: const Color(0xFF5A8151),
                      ),
                      Text(
                        'Ekstrakurikuler',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Time Slot Dropdown
                  DropdownButtonFormField<String>(
                    value: availableTimeSlots.contains(selectedTimeSlot) ? selectedTimeSlot : null,
                    decoration: InputDecoration(
                      labelText: 'Jam Pelajaran',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: availableTimeSlots.map((time) {
                      return DropdownMenuItem(value: time, child: Text(time));
                    }).toList(),
                    onChanged: (value) => selectedTimeSlot = value!,
                  ),
                  const SizedBox(height: 12),
                  
                  // Subject Dropdown
                  DropdownButtonFormField<String>(
                    value: availableSubjects.contains(selectedSubject) ? selectedSubject : null,
                    decoration: InputDecoration(
                      labelText: isExtra ? 'Ekstrakurikuler' : 'Mata Pelajaran',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: availableSubjects.map((subject) {
                      return DropdownMenuItem(value: subject, child: Text(subject));
                    }).toList(),
                    onChanged: (value) => selectedSubject = value!,
                  ),
                  const SizedBox(height: 12),
                  
                  // Teacher TextField
                  TextFormField(
                    initialValue: teacher,
                    decoration: InputDecoration(
                      labelText: isExtra ? 'Pembina/Pelatih (opsional)' : 'Nama Guru (opsional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) => teacher = value,
                  ),
                  const SizedBox(height: 12),
                  
                  // Room TextField
                  TextFormField(
                    initialValue: room,
                    decoration: InputDecoration(
                      labelText: isExtra ? 'Tempat Kegiatan (opsional)' : 'Ruangan (opsional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) => room = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.editScheduleItem(
                    id: item['id'],
                    timeSlot: selectedTimeSlot,
                    subject: selectedSubject,
                    teacher: teacher,
                    room: room,
                    isExtra: isExtra,
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A8151),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _showDeleteDialog(String id, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Hapus Jadwal',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal ini?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteScheduleItem(id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}