import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' show WebHtmlElementStrategy;
import 'package:flutter/services.dart';

import 'models/glossary_entry.dart';

class GlossaryEntryTile extends StatefulWidget {
  const GlossaryEntryTile({super.key, required this.entry});

  final GlossaryEntry entry;

  @override
  State<GlossaryEntryTile> createState() => _GlossaryEntryTileState();
}

class _GlossaryEntryTileState extends State<GlossaryEntryTile> {
  bool _expanded = false;

  bool get _hasImage =>
      widget.entry.imageUrl != null && widget.entry.imageUrl!.isNotEmpty;

  void _toggleExpanded() {
    if (!_hasImage) {
      return;
    }
    setState(() {
      _expanded = !_expanded;
    });
  }

  Future<void> _copySwedish(BuildContext context) async {
    final text = widget.entry.swedish;
    try {
      await Clipboard.setData(ClipboardData(text: text));
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
            'Could not copy automatically. Select and copy manually: $text',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;

    final surface = theme.colorScheme.surface;
    final cardColor = _hasImage
        ? Color.alphaBlend(
            theme.colorScheme.onSurface.withValues(alpha: 0.085),
            surface,
          )
        : surface;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: _hasImage ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: _hasImage
            ? BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.35),
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _hasImage ? _toggleExpanded : null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              entry.swedish,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: (theme.textTheme.titleLarge?.fontSize ??
                                        22) -
                                    1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.english,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontSize:
                                    (theme.textTheme.titleMedium?.fontSize ??
                                            16) +
                                        1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: IconButton(
                    tooltip: 'Copy Swedish term',
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copySwedish(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded && _hasImage
                ? InkWell(
                    onTap: _toggleExpanded,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            entry.imageUrl!,
                            fit: BoxFit.cover,
                            // Web (including phone browser / PWA): CanvasKit fetch needs
                            // Storage CORS; <img>+decode helps but iOS Safari can still
                            // require bucket CORS (see firebase/storage-cors.json).
                            webHtmlElementStrategy: kIsWeb
                                ? WebHtmlElementStrategy.prefer
                                : WebHtmlElementStrategy.never,
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
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
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
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
