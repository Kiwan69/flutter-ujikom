class TiketResponse {
  final int? id;
  final int stok;
  final int harga;
  final String kategori;
  final String status;
  final int idAcara;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TiketResponse({
    this.id,
    required this.stok,
    required this.harga,
    required this.kategori,
    required this.status,
    required this.idAcara,
    this.createdAt,
    this.updatedAt,
  });

  factory TiketResponse.fromJson(Map<String, dynamic> json) {
    return TiketResponse(
      id: json['id'],
      stok: json['stok'],
      harga: json['harga'],
      kategori: json['kategori'],
      status: json['status'],
      idAcara: json['id_acara'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stok': stok,
      'harga': harga,
      'kategori': kategori,
      'status': status,
      'id_acara': idAcara,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
