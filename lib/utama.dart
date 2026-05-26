import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'inti/konstanta.dart';
import 'inti/tema.dart';
import 'provider/catatan_provider.dart';
import 'rute/rute_aplikasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: TemaAplikasi.warnaLatarBelakang,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const AplikasiMyNotes());
}

class AplikasiMyNotes extends StatelessWidget {
  const AplikasiMyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatatanProvider(),
      child: MaterialApp(
        title: KonstantaAplikasi.namaAplikasi,
        theme: TemaAplikasi.tema,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RuteAplikasi.buatRute,
        initialRoute: RuteAplikasi.beranda,
      ),
    );
  }
}
