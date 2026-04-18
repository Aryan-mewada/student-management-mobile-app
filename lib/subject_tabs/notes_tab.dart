import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class NotesTab extends StatefulWidget {
  final String username;
  final String course;
  final int semester;
  final String subject;
  const NotesTab(
      {super.key,
        required this.username,
        required this.course,
        required this.semester,
        required this.subject});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await DatabaseHelper.instance.getNotes(
        widget.username, widget.course, widget.semester, widget.subject);
    if (mounted) setState(() => _notes = data);
  }

  void _showNoteDialog({Map<String, dynamic>? existing}) {
    final ctrl =
    TextEditingController(text: existing?['note_text'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing != null ? 'Edit Note' : 'Add Note'),
        content: TextField(
          controller: ctrl,
          maxLines: 8,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Write your note here...',
              border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              if (existing != null) {
                await DatabaseHelper.instance
                    .updateNote(existing['id'], ctrl.text.trim());
              } else {
                await DatabaseHelper.instance.addNote(
                    widget.username,
                    widget.course,
                    widget.semester,
                    widget.subject,
                    ctrl.text.trim());
              }
              Navigator.pop(ctx);
              _loadNotes();
            },
            child: Text(existing != null ? 'Update' : 'Save',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: _notes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('No notes yet',
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 16)),
            const SizedBox(height: 6),
            Text('Tap + to write notes',
                style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _notes.length,
        itemBuilder: (ctx, i) {
          final n = _notes[i];
          return Card(
            color: Colors.yellow.shade50,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: Colors.amber.shade300, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(n['created_at']),
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                size: 18, color: Colors.blue),
                            onPressed: () =>
                                _showNoteDialog(existing: n),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            onPressed: () async {
                              await DatabaseHelper.instance
                                  .deleteNote(n['id']);
                              _loadNotes();
                            },
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n['note_text'],
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () => _showNoteDialog(),
        icon: const Icon(Icons.add, color: Colors.white),
        label:
        const Text('Add Note', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}