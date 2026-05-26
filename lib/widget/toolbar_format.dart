import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../inti/tema.dart';

class ToolbarFormat extends StatelessWidget {
  final TextEditingController kontroler;
  final FocusNode fokus;

  const ToolbarFormat({
    super.key,
    required this.kontroler,
    required this.fokus,
  });

  // Wrap selection with prefix/suffix; if no selection, insert at cursor
  void _terapkanFormat(String prefiks, String sufiks) {
    final val = kontroler.value;
    final sel = val.selection;
    if (!sel.isValid) return;

    final teks = val.text;
    String baru;
    TextSelection selBaru;

    if (sel.isCollapsed) {
      baru = teks.replaceRange(sel.start, sel.start, '$prefiks$sufiks');
      selBaru = TextSelection.collapsed(offset: sel.start + prefiks.length);
    } else {
      final dipilih = sel.textInside(teks);
      baru = teks.replaceRange(sel.start, sel.end, '$prefiks$dipilih$sufiks');
      selBaru = TextSelection(
        baseOffset: sel.start,
        extentOffset: sel.start + prefiks.length + dipilih.length + sufiks.length,
      );
    }

    kontroler.value = val.copyWith(text: baru, selection: selBaru);
    fokus.requestFocus();
  }

  // Find start index of the current line based on cursor position
  int _indeksAwalBaris(String teks, int pos) {
    final idx = teks.lastIndexOf('\n', pos > 0 ? pos - 1 : 0);
    return idx < 0 ? 0 : idx + 1;
  }

  // Apply or toggle a prefix on the current line
  void _terapkanPrefixBaris(String prefix) {
    final val = kontroler.value;
    final sel = val.selection;
    if (!sel.isValid) return;

    final teks = val.text;
    final pos = sel.start;
    final indeksAwal = _indeksAwalBaris(teks, pos);

    final sebelum = teks.substring(0, indeksAwal);
    final barisDanSisa = teks.substring(indeksAwal);

    // Checklist: cycle ☐ → ☑ → (remove) → ☐
    if (prefix == '☐ ') {
      if (barisDanSisa.startsWith('☐ ')) {
        final baru = '$sebelum☑ ${barisDanSisa.substring(2)}';
        kontroler.value = val.copyWith(
          text: baru,
          selection: TextSelection.collapsed(offset: pos),
        );
        fokus.requestFocus();
        return;
      }
      if (barisDanSisa.startsWith('☑ ')) {
        final baru = '$sebelum${barisDanSisa.substring(2)}';
        kontroler.value = val.copyWith(
          text: baru,
          selection: TextSelection.collapsed(
            offset: (pos - 2).clamp(indeksAwal, baru.length),
          ),
        );
        fokus.requestFocus();
        return;
      }
    }

    // Generic toggle: add if absent, remove if present
    if (barisDanSisa.startsWith(prefix)) {
      final baru = '$sebelum${barisDanSisa.substring(prefix.length)}';
      kontroler.value = val.copyWith(
        text: baru,
        selection: TextSelection.collapsed(
          offset: (pos - prefix.length).clamp(indeksAwal, baru.length),
        ),
      );
    } else {
      // Strip any other list prefix first then add new one
      final prefixLain = ['• ', '☐ ', '☑ '];
      String barisBersih = barisDanSisa;
      int panjangDihapus = 0;
      for (final p in prefixLain) {
        if (barisDanSisa.startsWith(p)) {
          barisBersih = barisDanSisa.substring(p.length);
          panjangDihapus = p.length;
          break;
        }
      }
      final matchNomor = RegExp(r'^\d+\. ').firstMatch(barisDanSisa);
      if (matchNomor != null) {
        barisBersih = barisDanSisa.substring(matchNomor.end);
        panjangDihapus = matchNomor.end;
      }

      final baru = '$sebelum$prefix$barisBersih';
      final offsetBaru = (pos - panjangDihapus + prefix.length)
          .clamp(indeksAwal, baru.length);
      kontroler.value = val.copyWith(
        text: baru,
        selection: TextSelection.collapsed(offset: offsetBaru),
      );
    }
    fokus.requestFocus();
  }

  void _terapkanListBernomor() {
    final val = kontroler.value;
    final sel = val.selection;
    if (!sel.isValid) return;

    final teks = val.text;
    final pos = sel.start;
    final idxNewline = teks.lastIndexOf('\n', pos > 0 ? pos - 1 : 0);
    final indeksAwal = idxNewline < 0 ? 0 : idxNewline + 1;
    final sebelum = teks.substring(0, indeksAwal);
    final barisDanSisa = teks.substring(indeksAwal);

    // Toggle off if already numbered
    final matchAda = RegExp(r'^\d+\. ').firstMatch(barisDanSisa);
    if (matchAda != null) {
      final baru = '$sebelum${barisDanSisa.substring(matchAda.end)}';
      kontroler.value = val.copyWith(
        text: baru,
        selection: TextSelection.collapsed(
          offset: (pos - matchAda.end).clamp(indeksAwal, baru.length),
        ),
      );
      fokus.requestFocus();
      return;
    }

    // Find next number based on previous line
    int nomorBerikut = 1;
    if (idxNewline > 0) {
      final idxPrevNewline = teks.lastIndexOf('\n', idxNewline - 1);
      final barisSebe = teks.substring(
        idxPrevNewline < 0 ? 0 : idxPrevNewline + 1,
        idxNewline,
      );
      final matchSebe = RegExp(r'^(\d+)\. ').firstMatch(barisSebe);
      if (matchSebe != null) {
        nomorBerikut = int.parse(matchSebe.group(1)!) + 1;
      }
    }

    // Strip any existing list prefix
    String barisBersih = barisDanSisa;
    int panjangDihapus = 0;
    for (final p in ['• ', '☐ ', '☑ ']) {
      if (barisDanSisa.startsWith(p)) {
        barisBersih = barisDanSisa.substring(p.length);
        panjangDihapus = p.length;
        break;
      }
    }

    final prefix = '$nomorBerikut. ';
    final baru = '$sebelum$prefix$barisBersih';
    final offsetBaru = (pos - panjangDihapus + prefix.length)
        .clamp(indeksAwal, baru.length);
    kontroler.value = val.copyWith(
      text: baru,
      selection: TextSelection.collapsed(offset: offsetBaru),
    );
    fokus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: TemaAplikasi.warnaPermukaan2,
        border: Border(top: BorderSide(color: TemaAplikasi.orangeA20)),
      ),
      child: Row(
        children: [
          _TombolFormat(
            label: 'B',
            fontWeight: FontWeight.bold,
            tooltip: 'Bold  **teks**',
            onTap: () => _terapkanFormat('**', '**'),
          ),
          _TombolFormat(
            label: 'I',
            fontStyle: FontStyle.italic,
            tooltip: 'Italic  _teks_',
            onTap: () => _terapkanFormat('_', '_'),
          ),
          _TombolFormat(
            label: 'U',
            underline: true,
            tooltip: 'Underline  __teks__',
            onTap: () => _terapkanFormat('__', '__'),
          ),
          _TombolFormat(
            label: 'S',
            strikethrough: true,
            tooltip: 'Strikethrough  ~~teks~~',
            onTap: () => _terapkanFormat('~~', '~~'),
          ),
          const SizedBox(width: 6),
          Container(width: 1, height: 26, color: TemaAplikasi.warnaPermukaan3),
          const SizedBox(width: 6),
          _TombolFormat(
            icon: Icons.format_list_bulleted_rounded,
            tooltip: 'Bullet List',
            onTap: () => _terapkanPrefixBaris('• '),
          ),
          _TombolFormat(
            icon: Icons.format_list_numbered_rounded,
            tooltip: 'Numbered List',
            onTap: _terapkanListBernomor,
          ),
          _TombolFormat(
            icon: Icons.checklist_rounded,
            tooltip: 'Checklist  (ketuk lagi untuk centang)',
            onTap: () => _terapkanPrefixBaris('☐ '),
          ),
        ],
      ),
    );
  }
}

class _TombolFormat extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final bool underline;
  final bool strikethrough;
  final String tooltip;

  const _TombolFormat({
    this.label,
    this.icon,
    required this.onTap,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.underline = false,
    this.strikethrough = false,
    this.tooltip = '',
  });

  @override
  State<_TombolFormat> createState() => _TombolFormatState();
}

class _TombolFormatState extends State<_TombolFormat> {
  bool _ditekan = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _ditekan = true),
        onTapUp: (_) {
          setState(() => _ditekan = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _ditekan = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _ditekan ? TemaAplikasi.orangeA15 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  _ditekan ? TemaAplikasi.orangeA30 : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: _ditekan
                      ? TemaAplikasi.warnaOranye
                      : TemaAplikasi.warnaTeksSekunder,
                  size: 20,
                )
              : Text(
                  widget.label!,
                  style: GoogleFonts.inter(
                    color: _ditekan
                        ? TemaAplikasi.warnaOranye
                        : TemaAplikasi.warnaTeks,
                    fontSize: 15,
                    fontWeight: widget.fontWeight,
                    fontStyle: widget.fontStyle,
                    decoration: widget.underline
                        ? TextDecoration.underline
                        : widget.strikethrough
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: _ditekan
                        ? TemaAplikasi.warnaOranye
                        : TemaAplikasi.warnaTeks,
                    decorationThickness: 2,
                  ),
                ),
        ),
      ),
    );
  }
}
