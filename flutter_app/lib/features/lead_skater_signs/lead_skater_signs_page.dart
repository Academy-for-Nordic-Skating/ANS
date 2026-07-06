import 'package:flutter/material.dart';

import '../../ans_colors.dart';

/// Reference images for lead skater hand/body signs (English-only page).
class LeadSkaterSignsPage extends StatelessWidget {
  const LeadSkaterSignsPage({super.key});

  static const _imagePaths = <String>[
    'assets/images/lead-skater/sign-1.png',
    'assets/images/lead-skater/sign-2.png',
    'assets/images/lead-skater/sign-3.png',
  ];

  static const _desktopMaxWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      children: [
        Text(
          'Lead skater signs',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AnsColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < _imagePaths.length; i++) ...[
          _SignImage(path: _imagePaths[i], index: i + 1),
          if (i < _imagePaths.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _SignImage extends StatelessWidget {
  const _SignImage({required this.path, required this.index});

  final String path;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(0.0, LeadSkaterSignsPage._desktopMaxWidth);

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                path,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return ColoredBox(
                    color: AnsColors.rowBackground,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Sign $index image coming soon',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AnsColors.teal,
                                ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
