class AcaraResponse {
  final int? id;
  final String namaPertandingan;
  final DateTime tanggal;
  final String waktuMulai;
  final String waktuSelesai;
  final int idStadion;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AcaraResponse({
    this.id,
    required this.namaPertandingan,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.idStadion,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory AcaraResponse.fromJson(Map<String, dynamic> json) {
    return AcaraResponse(
      id: json['id'],
      namaPertandingan: json['nama_pertandingan'],
      tanggal: DateTime.parse(json['tanggal']),
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      idStadion: json['id_stadion'],
      image: json['image'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Jika Anda perlu mengirim data kembali ke backend (misalnya saat menambahkan atau mengedit)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pertandingan': namaPertandingan,
      'tanggal': tanggal.toIso8601String().split('T')[0], // Format tanggal ke YYYY-MM-DD
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'id_stadion': idStadion,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}