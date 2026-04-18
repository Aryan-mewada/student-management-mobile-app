import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AnnouncementsTab extends StatefulWidget {
  final String username;
  final String course;
  final int semester;
  final String subject;
  const AnnouncementsTab(
      {super.key,
        required this.username,
        required this.course,
        required this.semester,
        required this.subject});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getAnnouncements(
        widget.username, widget.course, widget.semester, widget.subject);
    if (mounted) setState(() => _items = data);
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description)),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              await DatabaseHelper.instance.addAnnouncement(
                  widget.username,
                  widget.course,
                  widget.semester,
                  widget.subject,
                  titleCtrl.text.trim(),
                  bodyCtrl.text.trim());
              Navigator.pop(ctx);
              _load();
            },
            child:
            const Text('Post', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: _items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign,
                size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('No announcements',
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 16)),
            const SizedBox(height: 6),
            Text('Tap + to post an announcement',
                style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        itemBuilder: (ctx, i) {
          final a = _items[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: Colors.orange, width: 4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(a['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                          onPressed: () async {
                            await DatabaseHelper.instance
                                .deleteAnnouncement(a['id']);
                            _load();
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    if (a['body'] != null &&
                        a['body'].toString().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(a['body'],
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13)),
                    ],
                    const SizedBox(height: 8),
                    Text(_formatDate(a['created_at']),
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Announce',
            style: TextStyle(color: Colors.white)),
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