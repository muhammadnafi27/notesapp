import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../inti/tema.dart';

class FabKustom extends StatefulWidget {
  final VoidCallback onTap;

  const FabKustom({super.key, required this.onTap});

  @override
  State<FabKustom> createState() => _FabKustomState();
}

class _FabKustomState extends State<FabKustom> {
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
        width: 64,
        height: 64,
        transform: _ditekan
            ? Matrix4.diagonal3Values(0.9, 0.9, 1.0)
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [TemaAplikasi.warnaOranye, TemaAplikasi.warnaOranye2],
          ),
          boxShadow: [
            BoxShadow(
              color: _ditekan
                  ? TemaAplikasi.orangeA30
                  : TemaAplikasi.orangeA50,
              blurRadius: _ditekan ? 10 : 28,
              spreadRadius: _ditekan ? 0 : 2,
            ),
          ],
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 450.ms,
          curve: Curves.elasticOut,
          delay: 150.ms,
        );
  }
}
