import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../inti/konstanta.dart';
import '../model/catatan.dart';
import '../provider/catatan_provider.dart';
import '../rute/rute_aplikasi.dart';
import 'animasi_teks_berjalan.dart';

class KartuCatatan extends StatefulWidget {
  final Catatan catatan;
  final int indeks;

  const KartuCatatan({
    super.key,
    required this.catatan,
    required this.indeks,
  });

  @override
  State<KartuCatatan> createState() => _KartuCatatanState();
}

class _KartuCatatanState extends State<KartuCatatan> {
  bool _dihover = false;

  static const Color _putih = Colors.white;
  static const Color _putih80 = Color(0xCCFFFFFF);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CatatanProvider>();
    final dipilih = provider.terpilih(widget.catatan);
    final modusSeleksi = provider.modusSeleksi;

    return MouseRegion(
      onEnter: (_) => setState(() => _dihover = true),
      onExit: (_) => setState(() => _dihover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (modusSeleksi) {
            provider.toggleSeleksi(widget.catatan);
          } else {
            Navigator.pushNamed(
              context,
              RuteAplikasi.editor,
              arguments: widget.catatan,
            );
          }
        },
        onLongPress: () {
          if (!modusSeleksi) provider.masukModusSeleksi(widget.catatan);
        },
        child: AnimatedContainer(
          duration: KonstantaAplikasi.durasiAnimasiPendek,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Selected = sedikit lebih gelap agar terasa berbeda
              colors: dipilih
                  ? const [Color(0xFFCC5200), Color(0xFFE06800)]
                  : const [Color(0xFFFF6B00), Color(0xFFFF9030)],
            ),
            borderRadius: BorderRadius.circular(
              KonstantaAplikasi.radiusBundaranBesar,
            ),
            border: Border.all(
              color: dipilih
                  ? const Color(0x60FFFFFF)
                  : _dihover
                  ? const Color(0x40FFFFFF)
                  : const Color(0x1AFFFFFF),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _dihover
                    ? const Color(0x70FF6B00)
                    : const Color(0x50FF6B00),
                blurRadius: _dihover ? 28 : 18,
                spreadRadius: _dihover ? 2 : 0,
                offset: const Offset(0, 6),
              ),
              const BoxShadow(
                color: Color(0x30000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glassmorphism: overlay putih saat dipilih
              if (dipilih)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        KonstantaAplikasi.radiusBundaranBesar,
                      ),
                      color: const Color(0x18FFFFFF),
                    ),
                  ),
                ),
              // Highlight strip di kiri atas
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(KonstantaAplikasi.radiusBundaranBesar),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0x50FFFFFF), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Konten kartu
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + checkmark
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.catatan.judul.isEmpty
                                ? 'Tanpa Judul'
                                : widget.catatan.judul,
                            style: GoogleFonts.inter(
                              color: _putih,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              shadows: const [
                                Shadow(
                                  color: Color(0x40000000),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (modusSeleksi) ...[
                          const SizedBox(width: 8),
                          AnimatedContainer(
                            duration: KonstantaAplikasi.durasiAnimasiPendek,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dipilih
                                  ? Colors.white
                                  : Colors.transparent,
                              border: Border.all(
                                color: dipilih
                                    ? Colors.white
                                    : const Color(0x80FFFFFF),
                                width: 2,
                              ),
                            ),
                            child: dipilih
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 13,
                                    color: dipilih
                                        ? const Color(0xFFCC5200)
                                        : Colors.transparent,
                                  )
                                : null,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Waktu realtime (putih transparan)
                    const AnimasiTeksBerjalan(
                      warna: Color(0xB3FFFFFF),
                    ),
                    const SizedBox(height: 10),
                    // Preview isi
                    Expanded(
                      child: Text(
                        widget.catatan.isi.isEmpty
                            ? 'Belum ada isi catatan...'
                            : _bersihkanPraview(widget.catatan.isi),
                        style: GoogleFonts.inter(
                          color: _putih80,
                          fontSize: 13,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.indeks * 60))
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  // Hapus marker format agar preview terlihat bersih
  String _bersihkanPraview(String teks) {
    return teks
        .replaceAll('**', '')
        .replaceAll('~~', '')
        .replaceAll('__', '')
        .replaceAll(RegExp(r'(?<!\*)\*(?!\*)'), '')
        .replaceAll(RegExp(r'(?<!_)_(?!_)'), '')
        .replaceAll('☐ ', '○ ')
        .replaceAll('☑ ', '✓ ')
        .trim();
  }

}
