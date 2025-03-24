import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../../../utils/api.dart';

class DashboardController extends GetxController {
  final _getConnect = GetConnect();
  var selectedIndex = 0.obs;

  final token = GetStorage().read('token');

  // Deklarasikan TextEditingController di sini agar dapat digunakan secara global dalam controller
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  // Mengambil event

  // Fungsi buat logout user
  void logOut() async {
    // Kirim request POST ke server buat logout
    final response = await _getConnect.post(
      BaseUrl.logout, // Endpoint buat logout
      {}, // Gak ada body karena logout aja
      headers: {'Authorization': "Bearer $token"}, // Header dengan token user
      contentType: "application/json", // Format data JSON
    );

    // Kalau server bilang logout sukses
    if (response.statusCode == 200) {
      // Kasih notifikasi logout berhasil
      Get.snackbar(
        'Success', // Judul snack bar
        'Logout Success', // Pesan sukses
        snackPosition: SnackPosition.BOTTOM, // Snack muncul di bawah
        backgroundColor: Colors.green, // Warna hijau biar good vibes
        colorText: Colors.white, // Teks putih biar jelas
      );

      // Hapus semua data user dari penyimpanan lokal
      GetStorage().erase();

      // Redirect user ke halaman login
      Get.offAllNamed('/login'); // Bersih-bersih dan langsung ke login
    } else {
      // Kalau gagal logout, kasih tau user
      Get.snackbar(
        'Failed', // Judul snack bar
        'Logout Failed', // Pesan error
        snackPosition: SnackPosition.BOTTOM, // Snack muncul di bawah
        backgroundColor: Colors.red, // Warna merah buat error vibes
        colorText: Colors.white, // Teks putih biar kontras
      );
    }
  }

  // Fungsi untuk mengubah halaman yang ditampilkan
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
  ];

  // Inisialisasi data ketika controller dimulai
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    eventDateController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
