import 'package:flutter/material.dart';

import 'glossary_entry_tile.dart';
import 'glossary_repository.dart'
    show GlossaryLoadException, GlossaryRepository;
import 'models/glossary_entry.dart';

const _ansLogoBannerAsset = 'assets/images/ANS-logo-banner.png';

class GlossaryPage extends StatefulWidget {
  const GlossaryPage({
    super.key,
    required this.repository,
    this.onAdminPressed,
  });

  final GlossaryRepository repository;

  /// Opens the glossary editor when set (e.g. from app routes).
  final VoidCallback? onAdminPressed;

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  late Future<List<GlossaryEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.fetchGlossary();
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.repository.fetchGlossary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 72,
        title: Image.asset(
          _ansLogoBannerAsset,
          height: 56,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          semanticLabel: 'Academy for Nordic Skating',
        ),
        centerTitle: false,
        actions: [
          if (widget.onAdminPressed != null)
            IconButton(
              tooltip: 'Glossary editor',
              onPressed: widget.onAdminPressed,
              icon: const Icon(Icons.edit_note_outlined),
            ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<GlossaryEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final err = snapshot.error;
            final message = err is GlossaryLoadException
                ? err.message
                : err.toString();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Could not load glossary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _reload,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }
          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No terms yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'When glossary entries are added in Firebase, they will appear here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return GlossaryEntryTile(entry: entries[index]);
            },
          );
        },
      ),
    );
  }
}
