import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../inti/tema.dart';
import '../../model/catatan.dart';
import '../../provider/catatan_provider.dart';
import '../../widget/toolbar_format.dart';

class HalamanEditor extends StatefulWidget {
  final Catatan? catatan;

  const HalamanEditor({super.key, this.catatan});

  @override
  State<HalamanEditor> createState() => _HalamanEditorState();
}

class _HalamanEditorState extends State<HalamanEditor> {
  late final TextEditingController _kontrolerJudul;
  late final TextEditingController _kontrolerIsi;
  late final FocusNode _fokusIsi;

  @override
  void initState() {
    super.initState();
    _kontrolerJudul = TextEditingController(
      text: widget.catatan?.judul ?? '',
    );
    _kontrolerIsi = TextEditingController(
      text: widget.catatan?.isi ?? '',
    );
    _fokusIsi = FocusNode();
  }

  @override
  void dispose() {
    _kontrolerJudul.dispose();
    _kontrolerIsi.dispose();
    _fokusIsi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final judul = _kontrolerJudul.text.trim();
    final isi = _kontrolerIsi.text.trim();

    if (judul.isEmpty && isi.isEmpty) return;

    final provider = context.read<CatatanProvider>();
    final sekarang = DateTime.now();

    if (widget.catatan != null) {
      await provider.perbarui(
        widget.catatan!.salin(
          judul: judul,
          isi: isi,
          tanggalDiperbarui: sekarang,
        ),
      );
    } else {
      await provider.tambah(
        Catatan(
          id: const Uuid().v4(),
          judul: judul,
          isi: isi,
          tanggalDibuat: sekarang,
          tanggalDiperbarui: sekarang,
        ),
      );
    }
  }

  void _kembali() async {
    final nav = Navigator.of(context);
    await _simpan();
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        await _simpan();
        nav.pop();
      },
      child: Scaffold(
        backgroundColor: TemaAplikasi.warnaLatarBelakang,
        body: SafeArea(
          child: Column(
            children: [
              _bangunHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input judul
                      TextField(
                        controller: _kontrolerJudul,
                        autofocus: widget.catatan == null,
                        style: GoogleFonts.inter(
                          color: TemaAplikasi.warnaTeks,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Judul catatan...',
                          hintStyle: GoogleFonts.inter(
                            color: const Color(0x40F5F5F5),
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _fokusIsi.requestFocus(),
                      ),
                      const SizedBox(height: 6),
                      // Divider oranye
                      Container(
                        height: 1.5,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TemaAplikasi.orangeA50,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Input isi catatan
                      TextField(
                        controller: _kontrolerIsi,
                        focusNode: _fokusIsi,
                        style: GoogleFonts.inter(
                          color: const Color(0xE6F5F5F5),
                          fontSize: 16,
                          height: 1.75,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tulis catatan di sini...',
                          hintStyle: GoogleFonts.inter(
                            color: const Color(0x40F5F5F5),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ),
              // Toolbar format — muncul di atas keyboard
              ToolbarFormat(
                kontroler: _kontrolerIsi,
                fokus: _fokusIsi,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bangunHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          _TombolKembali(onTap: _kembali),
          const Spacer(),
          const _BadgeAutoSave(),
        ],
      ),
    );
  }
}

// ── Tombol kembali warna oranye ─────────────────────────────────────────────

class _TombolKembali extends StatefulWidget {
  final VoidCallback onTap;

  const _TombolKembali({required this.onTap});

  @override
  State<_TombolKembali> createState() => _TombolKembaliState();
}

class _TombolKembaliState extends State<_TombolKembali> {
  bool _ditekan = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _ditekan = true),
      onTapUp: (_) {
        setState(() => _ditekan = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _ditekan = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        transform: _ditekan
            ? Matrix4.diagonal3Values(0.94, 0.94, 1)
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B00), Color(0xFFFF9030)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _ditekan
                  ? const Color(0x30FF6B00)
                  : const Color(0x55FF6B00),
              blurRadius: _ditekan ? 6 : 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0x30FFFFFF)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              'Kembali',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge Auto Save ──────────────────────────────────────────────────────────

class _BadgeAutoSave extends StatelessWidget {
  const _BadgeAutoSave();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TemaAplikasi.orangeA10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TemaAplikasi.orangeA20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.save_rounded, size: 14, color: Color(0xB3FF6B00)),
          SizedBox(width: 6),
          Text(
            'Auto Save',
            style: TextStyle(
              color: Color(0xB3FF6B00),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
