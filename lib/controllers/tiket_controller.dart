import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_ujikom/app/data/tiket_response.dart';
import 'package:project_ujikom/app/utils/api.dart';

class TiketController extends GetxController {
  var tiketList = <TiketResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTiket();
  }

  Future<void> fetchTiket() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.tiket));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        tiketList.value = data.map((json) => TiketResponse.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Gagal memuat data tiket (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal terhubung ke server: $e');
    }
  }
}
