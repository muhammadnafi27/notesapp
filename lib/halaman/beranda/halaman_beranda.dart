import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../inti/tema.dart';
import '../../inti/konstanta.dart';
import '../../model/catatan.dart';
import '../../provider/catatan_provider.dart';
import '../../rute/rute_aplikasi.dart';
import '../../widget/bilah_pencarian.dart';
import '../../widget/bilah_aksi_seleksi.dart';
import '../../widget/fab_kustom.dart';
import '../../widget/kartu_catatan.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatatanProvider>().muat();
    });
  }

  int _hitungKolum(double lebar) {
    if (lebar >= KonstantaAplikasi.lebarTablet) {
      return KonstantaAplikasi.kolumDesktop;
    }
    return KonstantaAplikasi.kolumTablet;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CatatanProvider>();
    final catatan = provider.catatanTersaring;
    final lebar = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: TemaAplikasi.warnaLatarBelakang,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bangunHeader(provider, lebar),
            Expanded(
              child: catatan.isEmpty
                  ? _bangunKeadaanKosong(provider)
                  : _bangunGrid(catatan, _hitungKolum(lebar)),
            ),
          ],
        ),
      ),
      floatingActionButton: provider.modusSeleksi
          ? null
          : FabKustom(
              onTap: () => Navigator.pushNamed(context, RuteAplikasi.editor),
            ),
    );
  }

  Widget _bangunHeader(CatatanProvider provider, double lebar) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: AnimatedSwitcher(
        duration: KonstantaAplikasi.durasiAnimasiSedang,
        child: provider.modusSeleksi
            ? const BilahAksiSeleksi()
            : _bangunJudul(provider, lebar),
      ),
    );
  }

  Widget _bangunJudul(CatatanProvider provider, double lebar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey('judul'),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Notes',
              style: GoogleFonts.inter(
                color: TemaAplikasi.warnaTeks,
                fontSize: lebar >= KonstantaAplikasi.lebarMobile ? 32 : 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.05),
            const SizedBox(width: 10),
            _BadgeCatatan(jumlah: provider.jumlahCatatan)
                .animate()
                .fadeIn(duration: 500.ms, delay: 100.ms),
          ],
        ),
        const SizedBox(height: 16),
        const BilahPencarian().animate().fadeIn(
          duration: 500.ms,
          delay: 150.ms,
        ),
      ],
    );
  }

  Widget _bangunKeadaanKosong(CatatanProvider provider) {
    final adaPencarian = provider.kueriPencarian.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ikonKosong(adaPencarian),
          const SizedBox(height: 24),
          Text(
            adaPencarian
                ? 'Tidak ada catatan\nyang cocok dengan pencarian'
                : 'Belum ada catatan',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: TemaAplikasi.warnaTeksSekunder,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          if (!adaPencarian) ...[
            const SizedBox(height: 8),
            Text(
              'Tekan  +  untuk membuat catatan baru',
              style: GoogleFonts.inter(
                color: const Color(0x60FFFFFF),
                fontSize: 13,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 350.ms),
          ],
        ],
      ),
    );
  }

  Widget _ikonKosong(bool adaPencarian) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TemaAplikasi.orangeA10,
        border: Border.all(color: TemaAplikasi.orangeA20, width: 1.5),
      ),
      child: Icon(
        adaPencarian
            ? Icons.search_off_rounded
            : Icons.sticky_note_2_rounded,
        size: 48,
        color: TemaAplikasi.warnaOranye,
      ),
    )
        .animate(onPlay: (ctrl) => ctrl.repeat(reverse: true))
        .scaleXY(begin: 1, end: 1.06, duration: 2000.ms, curve: Curves.easeInOut);
  }

  Widget _bangunGrid(List<Catatan> catatan, int jumlahKolum) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: jumlahKolum,
        crossAxisSpacing: KonstantaAplikasi.jarakKartu,
        mainAxisSpacing: KonstantaAplikasi.jarakKartu,
        mainAxisExtent: KonstantaAplikasi.tinggiKartu,
      ),
      itemCount: catatan.length,
      itemBuilder: (context, indeks) => KartuCatatan(
        catatan: catatan[indeks],
        indeks: indeks,
      ),
    );
  }
}

class _BadgeCatatan extends StatelessWidget {
  final int jumlah;

  const _BadgeCatatan({required this.jumlah});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: TemaAplikasi.orangeA15,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TemaAplikasi.orangeA30),
      ),
      child: Text(
        '$jumlah',
        style: GoogleFonts.inter(
          color: TemaAplikasi.warnaOranye,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
