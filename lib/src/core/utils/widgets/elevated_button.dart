import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// This is a custom elevated button
class EchoButton extends StatelessWidget {
  /// This is a custom elevated button constructor
  const EchoButton({required this.label, required this.onPressed, super.key});
  /// This is the label of the button
  final String label;
  /// This is the onPressed callback
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            // ignore: deprecated_member_use
            color: context.colorScheme.primary.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: context.colorScheme.primary,
          backgroundColor: context.colorScheme.primary,
          foregroundColor: Colors.white,
          fixedSize: const Size(350, 50),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
}
