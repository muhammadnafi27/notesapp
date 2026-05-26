import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../inti/tema.dart';
import '../provider/catatan_provider.dart';

class BilahPencarian extends StatefulWidget {
  const BilahPencarian({super.key});

  @override
  State<BilahPencarian> createState() => _BilahPencarianState();
}

class _BilahPencarianState extends State<BilahPencarian> {
  final TextEditingController _kontroler = TextEditingController();
  final FocusNode _fokus = FocusNode();
  bool _aktif = false;

  @override
  void initState() {
    super.initState();
    _fokus.addListener(() => setState(() => _aktif = _fokus.hasFocus));
  }

  @override
  void dispose() {
    _kontroler.dispose();
    _fokus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: TemaAplikasi.warnaPermukaan2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _aktif ? TemaAplikasi.warnaOranye : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: _aktif
            ? [
                BoxShadow(
                  color: TemaAplikasi.orangeA15,
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: _kontroler,
        focusNode: _fokus,
        style: GoogleFonts.inter(
          color: TemaAplikasi.warnaTeks,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'Cari catatan...',
          hintStyle: GoogleFonts.inter(color: TemaAplikasi.warnaTeksSekunder),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _aktif
                ? TemaAplikasi.warnaOranye
                : TemaAplikasi.warnaTeksSekunder,
          ),
          suffixIcon: _kontroler.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: TemaAplikasi.warnaTeksSekunder,
                  ),
                  onPressed: () {
                    _kontroler.clear();
                    context.read<CatatanProvider>().aturPencarian('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (nilai) {
          setState(() {});
          context.read<CatatanProvider>().aturPencarian(nilai);
        },
      ),
    );
  }
}
