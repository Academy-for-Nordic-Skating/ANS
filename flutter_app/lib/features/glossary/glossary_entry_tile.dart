import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/glossary_entry.dart';

class GlossaryEntryTile extends StatelessWidget {
  const GlossaryEntryTile({super.key, required this.entry});

  final GlossaryEntry entry;

  Future<void> _copySwedish(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: entry.swedish));
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Swedish term copied')),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not copy automatically. Select and copy manually: ${entry.swedish}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    entry.swedish,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy Swedish term',
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copySwedish(context),
                ),
              ],
            ),
            Text(
              entry.english,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            if (entry.imageUrl != null && entry.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    entry.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.image_not_supported_outlined,
                          color: theme.colorScheme.outline),
                      const SizedBox(width: 8),
                      Text(
                        'No image',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
