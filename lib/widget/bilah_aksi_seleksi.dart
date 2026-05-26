import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../inti/tema.dart';
import '../provider/catatan_provider.dart';

class BilahAksiSeleksi extends StatelessWidget {
  const BilahAksiSeleksi({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CatatanProvider>();

    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: TemaAplikasi.warnaPermukaan2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TemaAplikasi.orangeA30, width: 1),
            boxShadow: const [
              BoxShadow(
                color: TemaAplikasi.orangeA15,
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (provider.semuaTerpilih) {
                    provider.keluarModusSeleksi();
                  } else {
                    provider.pilihSemua();
                  }
                },
                icon: Icon(
                  provider.semuaTerpilih
                      ? Icons.deselect_rounded
                      : Icons.select_all_rounded,
                  color: TemaAplikasi.warnaOranye,
                ),
                tooltip:
                    provider.semuaTerpilih
                        ? 'Batal Pilih Semua'
                        : 'Pilih Semua',
              ),
              Expanded(
                child: Text(
                  '${provider.catatanTerpilih.length} dipilih',
                  style: GoogleFonts.inter(
                    color: TemaAplikasi.warnaTeks,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => _konfirmasiHapus(context, provider),
                icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                tooltip: 'Hapus',
              ),
              IconButton(
                onPressed: provider.keluarModusSeleksi,
                icon: const Icon(
                  Icons.close_rounded,
                  color: TemaAplikasi.warnaTeksSekunder,
                ),
                tooltip: 'Batal',
              ),
            ],
          ),
        )
        .animate()
        .slideY(begin: -1, end: 0, duration: 300.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 200.ms);
  }

  void _konfirmasiHapus(BuildContext context, CatatanProvider provider) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TemaAplikasi.warnaPermukaan2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Hapus Catatan',
          style: GoogleFonts.inter(
            color: TemaAplikasi.warnaTeks,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Hapus ${provider.catatanTerpilih.length} catatan yang dipilih?\n'
          'Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.inter(
            color: TemaAplikasi.warnaTeksSekunder,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(color: TemaAplikasi.warnaTeksSekunder),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.hapusTerpilih();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
