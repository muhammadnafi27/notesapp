import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimasiTeksBerjalan extends StatefulWidget {
  final Color warna;

  const AnimasiTeksBerjalan({
    super.key,
    this.warna = const Color(0xB3FFFFFF),
  });

  static const List<String> _namaHari = [
    'Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab',
  ];

  static const List<String> _namaBulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  @override
  State<AnimasiTeksBerjalan> createState() => _AnimasiTeksBerjalanState();
}

class _AnimasiTeksBerjalanState extends State<AnimasiTeksBerjalan> {
  late Timer _timer;
  DateTime _sekarang = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) setState(() => _sekarang = DateTime.now());
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _teksWaktu {
    final hari = AnimasiTeksBerjalan._namaHari[_sekarang.weekday % 7];
    final bulan = AnimasiTeksBerjalan._namaBulan[_sekarang.month - 1];
    final hh = _sekarang.hour.toString().padLeft(2, '0');
    final mm = _sekarang.minute.toString().padLeft(2, '0');
    final ss = _sekarang.second.toString().padLeft(2, '0');
    return '$hari, ${_sekarang.day} $bulan ${_sekarang.year}  •  $hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _teksWaktu,
      style: GoogleFonts.inter(
        color: widget.warna,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
