import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'features/admin/admin_shell.dart';
import 'features/glossary/glossary_page.dart';
import 'features/glossary/glossary_repository.dart';

String _initialRoute() {
  if (kIsWeb) {
    final path = Uri.base.path;
    if (path.startsWith('/admin')) {
      return '/admin';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: _initialRoute(),
      routes: {
        '/': (context) => GlossaryPage(
              repository: repository,
              onAdminPressed: () {
                Navigator.of(context).pushNamed('/admin');
              },
            ),
        '/admin': (context) => const AdminShell(),
      },
    );
  }
}
