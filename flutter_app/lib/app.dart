import 'package:flutter/material.dart';

import 'features/glossary/glossary_page.dart';
import 'features/glossary/glossary_repository.dart';

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
      home: GlossaryPage(repository: repository),
    );
  }
}
