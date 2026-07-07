import 'package:flutter/material.dart';

import '../../ans_colors.dart';
import '../glossary/glossary_page.dart';
import '../glossary/glossary_repository.dart';
import '../lead_skater_signs/lead_skater_signs_page.dart';
import 'ans_logo_title.dart';
import 'app_section.dart';

/// Shared scaffold: drawer navigation, ANS app bar, and active public section.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.section,
    required this.repository,
    this.onAdminPressed,
  });

  final AppSection section;
  final GlossaryRepository repository;
  final VoidCallback? onAdminPressed;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _glossaryKey = GlobalKey<GlossaryPageState>();

  void _navigateTo(AppSection section) {
    Navigator.pop(context);
    if (section == widget.section) {
      return;
    }
    Navigator.pushReplacementNamed(context, section.route);
  }

  IconData _drawerLeadingIcon(AppSection section) {
    switch (section) {
      case AppSection.glossary:
        return Icons.menu_book_outlined;
      case AppSection.leadSkaterSigns:
        return Icons.ads_click_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Release web builds tree-shake Material Icons; keep drawer glyphs referenced.
    return Stack(
      children: [
        const Offstage(
          child: Icon(Icons.ads_click_outlined),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AnsColors.navy,
        iconTheme: const IconThemeData(color: AnsColors.navy),
        toolbarHeight: 72,
        title: const AnsLogoTitle(),
        centerTitle: false,
        actions: [
          if (widget.onAdminPressed != null)
            IconButton(
              tooltip: 'Glossary editor',
              onPressed: widget.onAdminPressed,
              icon: const Icon(Icons.edit_note_outlined),
            ),
          if (widget.section == AppSection.glossary)
            IconButton(
              tooltip: 'Refresh',
              onPressed: () => _glossaryKey.currentState?.reload(),
              icon: const Icon(Icons.refresh),
            ),
        ],
          ),
          drawer: Drawer(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Text(
                            'Academy for Nordic Skating',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AnsColors.navy,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const Divider(height: 1),
                        for (final section in AppSection.values)
                          ListTile(
                            leading: Icon(
                              _drawerLeadingIcon(section),
                              color: widget.section == section
                                  ? AnsColors.teal
                                  : AnsColors.navy,
                            ),
                            title: Text(
                              section.drawerLabel,
                              style: TextStyle(
                                color: widget.section == section
                                    ? AnsColors.teal
                                    : AnsColors.navy,
                                fontWeight: widget.section == section
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            selected: widget.section == section,
                            onTap: () => _navigateTo(section),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: switch (widget.section) {
            AppSection.glossary => GlossaryPage(
                key: _glossaryKey,
                repository: widget.repository,
              ),
            AppSection.leadSkaterSigns => const LeadSkaterSignsPage(),
          },
        ),
      ],
    );
  }
}
