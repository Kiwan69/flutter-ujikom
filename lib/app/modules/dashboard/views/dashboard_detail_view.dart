import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ujikom/app/data/acara_response.dart';

class DetailAcaraView extends StatelessWidget {
  final AcaraResponse acara;

  const DetailAcaraView({Key? key, required this.acara}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(acara.namaPertandingan),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tampilkan Gambar
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  acara.image,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 200,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tampilkan Nama Pertandingan
            Text(
              acara.namaPertandingan,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tampilkan Tanggal
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
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Anda bisa menambahkan detail lain dari AcaraResponse di sini
            // Contoh:
            // Row(
            //   children: [
            //     const Icon(
            //       Icons.location_on,
            //       size: 16,
            //       color: Colors.grey,
            //     ),
            //     const SizedBox(width: 5),
            //     Text(
            //       acara.stadion, // Asumsi ada properti stadion
            //       style: const TextStyle(
            //         fontSize: 16,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),

            // Tambahkan detail lain sesuai kebutuhan Anda
          ],
        ),
      ),
    );
  }
}