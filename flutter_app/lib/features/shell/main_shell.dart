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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  'Academy for Nordic Skating',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AnsColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Divider(height: 1),
              for (final section in AppSection.values)
                ListTile(
                  leading: Icon(
                    section.drawerIcon,
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
      body: switch (widget.section) {
        AppSection.glossary => GlossaryPage(
            key: _glossaryKey,
            repository: widget.repository,
          ),
        AppSection.leadSkaterSigns => const LeadSkaterSignsPage(),
      },
    );
  }
}
