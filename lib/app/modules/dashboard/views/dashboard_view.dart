import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ujikom/app/data/acara_response.dart';
import 'package:project_ujikom/app/modules/dashboard/views/dashboard_detail_view.dart';
import 'package:project_ujikom/app/modules/dashboard/views/profile_view.dart'; 

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late Future<List<AcaraResponse>> futureAcara;
  int _selectedIndex = 0;
  late Widget _body; // Widget untuk menyimpan body yang aktif

  @override
  void initState() {
    super.initState();
    futureAcara = fetchAcara();
    _body = _buildAcaraBody(); // Inisialisasi body dengan halaman acara
  }

  Future<List<AcaraResponse>> fetchAcara() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/acaras'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      // ✅ Print seluruh data API untuk debugging
      print('Response API: $jsonResponse');

      return jsonResponse.map<AcaraResponse>((acara) {
        // ✅ Print URL gambar setiap acara
        print('Image URL: ${acara['image']}');
        // ✅ Gabungkan base URL dengan path gambar
        String baseUrl =
            'http://127.0.0.1:8000/storage/acaras'; // Ganti dengan URL backend Anda jika berbeda
        String fullImageUrl = '$baseUrl${acara['image']}';

        // ✅ Print URL gambar yang akan ditampilkan
        print('Full Image URL: $fullImageUrl');

        // ✅ Pastikan Anda menggunakan fullImageUrl saat membuat AcaraResponse
        return AcaraResponse.fromJson(acara..['image'] = fullImageUrl);
      }).toList();
    } else {
      throw Exception('Failed to load acara');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _body = _buildAcaraBody(); // Set body ke halaman acara
      } else if (index == 1) {
        _body = const ProfileView(); // Set body ke halaman profil
      }
    });
  }

  // Widget untuk membangun body halaman Acara
  Widget _buildAcaraBody() {
    return FutureBuilder<List<AcaraResponse>>(
      future: futureAcara,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada pertandingan yang ditemukan',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              AcaraResponse acara = snapshot.data![index];
              // ✅ Print URL gambar sebelum menampilkannya
              print('Displaying Image: ${acara.image}');
              return InkWell( // Tambahkan InkWell di sini
                onTap: () {
                  Get.to(() => DetailAcaraView(acara: acara));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        child: Image.network(
                          acara.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                acara.namaPertandingan,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${acara.tanggal.toLocal()}'.split(' ')[0],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StadiGo'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _body, // Gunakan _body sebagai body dari Scaffold
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Acara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}