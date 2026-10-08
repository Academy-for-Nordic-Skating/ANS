import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ans_colors.dart';

/// Tour report skeleton templates in English and Dutch, each with clipboard copy.
class TourReportTemplatePage extends StatelessWidget {
  const TourReportTemplatePage({super.key});

  static const _desktopMaxWidth = 720.0;

  static const englishTemplate = '''Our plan and why

What worked and what didn't?

Notable conditions: terrain, ice, weather, group

What went well and what could be improved?''';

  static const dutchTemplate = '''Ons plan en de reden erachter

Wat lukte en wat lukte niet?

Opvallende omstandigheden: terrein, ijs, weer, groep

Wat ging goed wat kon beter?''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _desktopMaxWidth),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
          children: [
            Text(
              'Tour report template',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AnsColors.navy,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _TemplateSection(
              title: 'English',
              body: englishTemplate,
              copiedMessage: 'English template copied',
            ),
            const SizedBox(height: 16),
            _TemplateSection(
              title: 'Dutch',
              body: dutchTemplate,
              copiedMessage: 'Dutch template copied',
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({
    required this.title,
    required this.body,
    required this.copiedMessage,
  });

  final String title;
  final String body;
  final String copiedMessage;

  Future<void> _copy(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: body));
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(copiedMessage)),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not copy automatically. Select and copy manually:\n$body',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AnsColors.rowBackground,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AnsColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy template',
                  icon: const Icon(Icons.copy, color: AnsColors.navy),
                  onPressed: () => _copy(context),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SelectableText(
                body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AnsColors.teal,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
