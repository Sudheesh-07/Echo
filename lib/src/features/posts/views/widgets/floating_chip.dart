import 'package:flutter/material.dart';

class FloatingChip extends StatefulWidget {
  final String text;
  final bool isUp;
  final Offset startPosition;
  final VoidCallback onComplete;

  const FloatingChip({
    super.key,
    required this.text,
    required this.isUp,
    required this.startPosition,
    required this.onComplete,
  });

  @override
  State<FloatingChip> createState() => _FloatingChipState();
}

class _FloatingChipState extends State<FloatingChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _translateAnimation = Tween<double>(
      begin: 0.0,
      end: widget.isUp ? -50.0 : 50.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder:
        (BuildContext context, Widget? child) => Positioned(
          left: widget.startPosition.dx - 30, // Center the chip
          top: widget.startPosition.dy + _translateAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.isUp ? Colors.green[600] : Colors.red[600],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
  );
}
