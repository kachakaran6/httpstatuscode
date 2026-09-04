import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Syntax-highlighted code block for displaying JSON examples.
class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String label;
  final VoidCallback? onCopy;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.label = 'Example Response',
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy'),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                textStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                onCopy?.call();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0D0D0D)
                : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFDDDDDD),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: SelectableText(
            code,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.55,
              color: isDark
                  ? const Color(0xFF98FB98)
                  : const Color(0xFF1B5E20),
            ),
          ),
        ),
      ],
    );
  }
}
