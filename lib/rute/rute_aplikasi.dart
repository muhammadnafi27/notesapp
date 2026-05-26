import 'package:flutter/material.dart';
import '../halaman/beranda/halaman_beranda.dart';
import '../halaman/editor_catatan/halaman_editor.dart';
import '../model/catatan.dart';

class RuteAplikasi {
  static const String beranda = '/';
  static const String editor = '/editor';

  static Route<dynamic> buatRute(RouteSettings pengaturan) {
    switch (pengaturan.name) {
      case editor:
        final catatan = pengaturan.arguments as Catatan?;
        return _buatTransisiGeser(HalamanEditor(catatan: catatan));
      case beranda:
      default:
        return _buatTransisiGeser(const HalamanBeranda());
    }
  }

  static PageRoute<T> _buatTransisiGeser<T>(Widget halaman) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animasi, animasiSekunder) => halaman,
      transitionsBuilder: (context, animasi, animasiSekunder, anak) {
        const mulai = Offset(1.0, 0.0);
        const kurva = Curves.easeInOutCubic;
        final tween = Tween(
          begin: mulai,
          end: Offset.zero,
        ).chain(CurveTween(curve: kurva));
        return SlideTransition(
          position: animasi.drive(tween),
          child: FadeTransition(opacity: animasi, child: anak),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
