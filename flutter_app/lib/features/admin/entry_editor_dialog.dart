import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String _contentTypeForFileName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) {
    return 'image/png';
  }
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (lower.endsWith('.gif')) {
    return 'image/gif';
  }
  if (lower.endsWith('.webp')) {
    return 'image/webp';
  }
  return 'application/octet-stream';
}

/// Create ([docId] null) or edit an existing glossary entry.
Future<void> showEntryEditorDialog(
  BuildContext context, {
  String? docId,
  Map<String, dynamic>? initial,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _EntryEditorDialog(
      docId: docId,
      initial: initial,
    ),
  );
}

class _EntryEditorDialog extends StatefulWidget {
  const _EntryEditorDialog({
    this.docId,
    this.initial,
  });

  final String? docId;
  final Map<String, dynamic>? initial;

  @override
  State<_EntryEditorDialog> createState() => _EntryEditorDialogState();
}

class _EntryEditorDialogState extends State<_EntryEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _swedishController;
  late final TextEditingController _englishController;
  late final TextEditingController _sortOrderController;
  bool _saving = false;
  String? _pickedLabel;
  Uint8List? _pickedBytes;
  String? _pickedFileName;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _swedishController = TextEditingController(text: i?['swedish'] as String? ?? '');
    _englishController = TextEditingController(text: i?['english'] as String? ?? '');
    final so = i?['sortOrder'];
    _sortOrderController = TextEditingController(
      text: so is num ? so.toString() : '',
    );
  }

  @override
  void dispose() {
    _swedishController.dispose();
    _englishController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  int _parseSortOrder() {
    final t = _sortOrderController.text.trim();
    if (t.isEmpty) {
      return 1000000;
    }
    return int.tryParse(t) ?? 1000000;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final f = result.files.single;
    final bytes = f.bytes;
    if (bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not read image data')),
        );
      }
      return;
    }
    setState(() {
      _pickedBytes = bytes;
      _pickedFileName = f.name;
      _pickedLabel = f.name;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _saving = true;
    });
    try {
      final swedish = _swedishController.text.trim();
      final english = _englishController.text.trim();
      final sortOrder = _parseSortOrder();

      final col = FirebaseFirestore.instance.collection('glossary_entries');
      final docRef =
          widget.docId != null ? col.doc(widget.docId!) : col.doc();
      final id = docRef.id;

      await docRef.set(
        {
          'swedish': swedish,
          'english': english,
          'sortOrder': sortOrder,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: widget.docId != null),
      );

      if (_pickedBytes != null && _pickedFileName != null) {
        final safeName = _pickedFileName!.replaceAll(RegExp(r'[^\w.\-]'), '_');
        final path = 'glossary/$id/$safeName';
        final ref = FirebaseStorage.instance.ref(path);
        await ref.putData(
          _pickedBytes!,
          SettableMetadata(contentType: _contentTypeForFileName(safeName)),
        );
        await docRef.update({'imageStoragePath': path});
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.docId == null ? 'New term' : 'Edit term'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _swedishController,
                decoration: const InputDecoration(
                  labelText: 'Swedish',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _englishController,
                decoration: const InputDecoration(
                  labelText: 'English',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sortOrderController,
                decoration: const InputDecoration(
                  labelText: 'Sort order (optional)',
                  border: OutlineInputBorder(),
                  helperText: 'Lower numbers appear first; default 1000000',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: Text(
                  _pickedLabel ?? 'Pick image (optional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
