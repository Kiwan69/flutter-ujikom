import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ujikom/app/data/acara_response.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late Future<List<AcaraResponse>> futureAcara;

  @override
  void initState() {
    super.initState();
    futureAcara = fetchAcara();
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
        return AcaraResponse.fromJson(acara);
      }).toList();
    } else {
      throw Exception('Failed to load acara');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<AcaraResponse>>(
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
                return Card(
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
