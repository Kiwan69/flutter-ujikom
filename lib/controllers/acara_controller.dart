import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_ujikom/app/data/acara_response.dart';
import 'package:project_ujikom/app/utils/api.dart';
import 'dart:convert';
// import '../data/acara_response.dart';
// import '../utils/api.dart';

class AcaraController extends GetxController {
  var acaraList = <AcaraResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAcara();
  }

  Future<void> fetchAcara() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.acara));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        acaraList.value = data.map((json) => AcaraResponse.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch acara data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
    }
  }
}