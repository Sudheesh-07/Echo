import 'package:echo/src/features/posts/views/widgets/floating_chip.dart';
import 'package:flutter/material.dart';

void _showFloatingChip(String text, bool isUp, BuildContext context, 
  {required GlobalKey upArrowKey, required GlobalKey downArrowKey}) {
  final GlobalKey targetKey = isUp ? upArrowKey : downArrowKey;
  final RenderBox? renderBox =
      targetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final position = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder:
        (context) => FloatingChip(
          text: text,
          isUp: isUp,
          startPosition: Offset(
            position.dx + size.width / 2,
            position.dy + size.height / 2,
          ),
          onComplete: () => overlayEntry.remove(),
        ),
  );

  overlay.insert(overlayEntry);
}
