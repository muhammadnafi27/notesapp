import 'dart:convert';

class Catatan {
  final String id;
  final String judul;
  final String isi;
  final DateTime tanggalDibuat;
  final DateTime tanggalDiperbarui;

  const Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggalDibuat,
    required this.tanggalDiperbarui,
  });

  Catatan salin({
    String? id,
    String? judul,
    String? isi,
    DateTime? tanggalDibuat,
    DateTime? tanggalDiperbarui,
  }) {
    return Catatan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      tanggalDiperbarui: tanggalDiperbarui ?? this.tanggalDiperbarui,
    );
  }

  Map<String, dynamic> keMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggalDibuat': tanggalDibuat.toIso8601String(),
      'tanggalDiperbarui': tanggalDiperbarui.toIso8601String(),
    };
  }

  factory Catatan.dariMap(Map<String, dynamic> map) {
    return Catatan(
      id: map['id'] as String,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
      tanggalDibuat: DateTime.parse(map['tanggalDibuat'] as String),
      tanggalDiperbarui: DateTime.parse(map['tanggalDiperbarui'] as String),
    );
  }

  String keJson() => jsonEncode(keMap());

  factory Catatan.dariJson(String source) =>
      Catatan.dariMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Catatan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
