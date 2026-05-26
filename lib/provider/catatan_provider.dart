import 'package:flutter/foundation.dart';
import '../model/catatan.dart';
import '../layanan/penyimpanan.dart';

class CatatanProvider extends ChangeNotifier {
  final LayananPenyimpanan _penyimpanan = LayananPenyimpanan();

  List<Catatan> _semuaCatatan = [];
  List<Catatan> _catatanTerpilih = [];
  String _kueriPencarian = '';
  bool _modusSeleksi = false;

  List<Catatan> get catatanTersaring {
    if (_kueriPencarian.isEmpty) return List.from(_semuaCatatan);
    final kueri = _kueriPencarian.toLowerCase();
    return _semuaCatatan
        .where(
          (c) =>
              c.judul.toLowerCase().contains(kueri) ||
              c.isi.toLowerCase().contains(kueri),
        )
        .toList();
  }

  List<Catatan> get catatanTerpilih => List.from(_catatanTerpilih);
  bool get modusSeleksi => _modusSeleksi;
  String get kueriPencarian => _kueriPencarian;
  int get jumlahCatatan => _semuaCatatan.length;

  bool get semuaTerpilih =>
      catatanTersaring.isNotEmpty &&
      _catatanTerpilih.length == catatanTersaring.length;

  bool terpilih(Catatan catatan) => _catatanTerpilih.contains(catatan);

  Future<void> muat() async {
    _semuaCatatan = await _penyimpanan.muatSemuaCatatan();
    notifyListeners();
  }

  Future<void> tambah(Catatan catatan) async {
    _semuaCatatan.insert(0, catatan);
    await _penyimpanan.simpanSemuaCatatan(_semuaCatatan);
    notifyListeners();
  }

  Future<void> perbarui(Catatan catatan) async {
    final indeks = _semuaCatatan.indexWhere((c) => c.id == catatan.id);
    if (indeks != -1) {
      _semuaCatatan[indeks] = catatan;
      await _penyimpanan.simpanSemuaCatatan(_semuaCatatan);
      notifyListeners();
    }
  }

  Future<void> hapusTerpilih() async {
    final idTerpilih = _catatanTerpilih.map((c) => c.id).toSet();
    _semuaCatatan.removeWhere((c) => idTerpilih.contains(c.id));
    _catatanTerpilih.clear();
    _modusSeleksi = false;
    await _penyimpanan.simpanSemuaCatatan(_semuaCatatan);
    notifyListeners();
  }

  void aturPencarian(String kueri) {
    _kueriPencarian = kueri;
    notifyListeners();
  }

  void masukModusSeleksi(Catatan catatan) {
    _modusSeleksi = true;
    _catatanTerpilih = [catatan];
    notifyListeners();
  }

  void keluarModusSeleksi() {
    _modusSeleksi = false;
    _catatanTerpilih.clear();
    notifyListeners();
  }

  void toggleSeleksi(Catatan catatan) {
    if (_catatanTerpilih.contains(catatan)) {
      _catatanTerpilih.remove(catatan);
      if (_catatanTerpilih.isEmpty) _modusSeleksi = false;
    } else {
      _catatanTerpilih.add(catatan);
    }
    notifyListeners();
  }

  void pilihSemua() {
    _catatanTerpilih = List.from(catatanTersaring);
    notifyListeners();
  }
}
