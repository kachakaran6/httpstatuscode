import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Rounded badge showing the HTTP status code number.
class StatusCodeBadge extends StatelessWidget {
  final int code;
  final String colorHex;
  final double fontSize;

  const StatusCodeBadge({
    super.key,
    required this.code,
    required this.colorHex,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.colorFromHex(colorHex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        code.toString(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
