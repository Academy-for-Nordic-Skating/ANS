import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'ans_colors.dart';
import 'features/admin/admin_shell.dart';
import 'features/glossary/glossary_repository.dart';
import 'features/shell/app_section.dart';
import 'features/shell/main_shell.dart';

String _initialRoute() {
  if (kIsWeb) {
    final path = Uri.base.path;
    if (path.startsWith('/admin')) {
      return '/admin';
    }
    final section = appSectionFromPath(path);
    if (section != null) {
      return section.route;
    }
  }
  return '/';
}

class AnsApp extends StatelessWidget {
  const AnsApp({super.key, required this.repository});

  final GlossaryRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academy for Nordic Skating',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AnsColors.teal,
          onPrimary: Colors.white,
          onSurface: AnsColors.navy,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: _initialRoute(),
      routes: {
        '/': (context) => MainShell(
              section: AppSection.glossary,
              repository: repository,
              onAdminPressed: () => Navigator.of(context).pushNamed('/admin'),
            ),
        '/glossary': (context) => MainShell(
              section: AppSection.glossary,
              repository: repository,
              onAdminPressed: () => Navigator.of(context).pushNamed('/admin'),
            ),
        '/lead-skater-signs': (context) => MainShell(
              section: AppSection.leadSkaterSigns,
              repository: repository,
              onAdminPressed: () => Navigator.of(context).pushNamed('/admin'),
            ),
        '/admin': (context) => const AdminShell(),
      },
    );
  }
}
