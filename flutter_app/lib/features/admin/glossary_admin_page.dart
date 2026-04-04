import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'entry_editor_dialog.dart';

class GlossaryAdminPage extends StatelessWidget {
  const GlossaryAdminPage({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete term'),
        content: const Text('Delete this glossary entry? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) {
      return;
    }
    try {
      final path = data['imageStoragePath'] as String?;
      if (path != null && path.isNotEmpty) {
        try {
          await FirebaseStorage.instance.ref(path).delete();
        } on Object {
          // best-effort
        }
      }
      await FirebaseFirestore.instance
          .collection('glossary_entries')
          .doc(docId)
          .delete();
    } on Object catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossary editor'),
        leading: BackButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('glossary_entries')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          final sorted = [...docs]..sort((a, b) {
              final ao =
                  (a.data()['sortOrder'] as num?)?.toInt() ?? 1000000;
              final bo =
                  (b.data()['sortOrder'] as num?)?.toInt() ?? 1000000;
              if (ao != bo) {
                return ao.compareTo(bo);
              }
              final sa = (a.data()['swedish'] as String?) ?? '';
              final sb = (b.data()['swedish'] as String?) ?? '';
              return sa.compareTo(sb);
            });

          if (sorted.isEmpty) {
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
                      'No entries yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a term with the + button.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sorted.length,
            itemBuilder: (context, i) {
              final doc = sorted[i];
              final d = doc.data();
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text((d['swedish'] as String?) ?? ''),
                  subtitle: Text((d['english'] as String?) ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => showEntryEditorDialog(
                          context,
                          docId: doc.id,
                          initial: d,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, doc.id, d),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEntryEditorDialog(context),
        tooltip: 'Add term',
        child: const Icon(Icons.add),
      ),
    );
  }
}
