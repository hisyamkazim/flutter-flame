import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownOverlay extends StatefulWidget {
  final VoidCallback onCountdownComplete;

  const CountdownOverlay({super.key, required this.onCountdownComplete});

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> {
  int _count = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _count--;
      });

      if (_count < 0) {
        widget.onCountdownComplete();
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Text(
          _count == 0 ? 'GO!' : _count.toString(),
          style: GoogleFonts.pixelifySans(
            fontSize: 72,
            color: _count == 0 ? Colors.green : Colors.white,
            shadows: [
              Shadow(
                color: _count == 0
                    ? const Color.fromARGB(255, 236, 245, 241)
                    : Colors.white70,
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
