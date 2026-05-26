import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/catatan.dart';

class LayananPenyimpanan {
  static const String _kunciCatatan = 'daftar_catatan';

  Future<List<Catatan>> muatSemuaCatatan() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kunciCatatan);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => Catatan.dariMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> simpanSemuaCatatan(List<Catatan> catatan) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = catatan.map((c) => c.keMap()).toList();
    await prefs.setString(_kunciCatatan, jsonEncode(jsonList));
  }
}
