import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_ujikom/app/utils/api.dart';
import 'package:project_ujikom/app/modules/dashboard/views/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final _getConnect = GetConnect();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authToken = GetStorage();

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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void loginNow() async {
    final response = await _getConnect.post(BaseUrl.login, {
      'email': emailController.text,
      'password': passwordController.text,
    });

    if (response.statusCode == 200) {
      final data = response.body;
      final token = data['acces_token']; // <- sesuai respons API kamu
      print('Token didapat: $token');

      // Simpan token ke GetStorage (jika masih digunakan)
      authToken.write('token', token);

      // Simpan token juga ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('Token disimpan di SharedPreferences: $token');

      // Pindah ke dashboard
      Get.offAll(() => const DashboardView());
    } else {
      Get.snackbar(
        'Login Gagal',
        response.body['message'] ?? 'Email atau password salah',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        forwardAnimationCurve: Curves.bounceIn,
        margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
      );
    }
  }
}
