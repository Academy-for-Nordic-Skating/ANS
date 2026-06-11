import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ans_colors.dart';
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AnsColors.rowBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide.none,
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
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: IconButton(
                    tooltip: 'Copy Swedish term',
                    icon: const Icon(Icons.copy, color: AnsColors.navy),
                    onPressed: () => _copySwedish(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _hasImage ? _toggleExpanded : null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              entry.swedish,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AnsColors.navy,
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
                                color: AnsColors.teal,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    (theme.textTheme.titleMedium?.fontSize ??
                                            16) +
                                        1,
                              ),
                            ),
                          ),
                          if (_hasImage) ...[
                            const SizedBox(width: 4),
                            AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AnsColors.teal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
