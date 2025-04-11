import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:get/get.dart'; // Import Get

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _name = 'Loading...'; // Inisialisasi dengan status loading
  String _email = 'Loading...';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      print('Token: $token');

      if (token == null) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan. Silakan login kembali.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/user',
        ), // Ganti endpoint ke yang benar
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json', // <- kadang perlu ini juga
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _name = data['name'] ?? 'Nama Tidak Tersedia';
          _email = data['email'] ?? 'Email Tidak Tersedia';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Gagal memuat profil. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan saat memuat profil: $error';
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk logout
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Hapus token dari shared_preferences

    // Navigasi ke halaman login
    Get.offAllNamed('/login'); // Asumsi Anda menggunakan GetX routes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              const CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/847/847969.png', // default user profile icon
                ), // Ganti dengan URL gambar avatar Anda (mungkin dari data API juga)
              ),
              const SizedBox(height: 20),

              // Nama
              Text(
                _name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Email
              Text(
                _email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Tombol Logout
              ElevatedButton(
                onPressed: _logout, // Panggil fungsi logout
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
