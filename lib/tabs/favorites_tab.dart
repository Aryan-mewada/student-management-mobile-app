import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../pages/subject_detail_page.dart';

class FavoritesTab extends StatefulWidget {
  final String username;
  const FavoritesTab({super.key, required this.username});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  List<Map<String, dynamic>> _favs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getFavorites(widget.username);
    if (mounted) setState(() => _favs = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: _favs.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border,
                size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('No favorites yet',
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 16)),
            const SizedBox(height: 6),
            Text('Star a subject to save it here',
                style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _favs.length,
          itemBuilder: (ctx, i) {
            final f = _favs[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.star, color: Colors.amber),
                ),
                title: Text(f['subject'],
                    style:
                    const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${f['course']} • Sem ${f['semester']}',
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SubjectDetailPage(
                              username: widget.username,
                              course: f['course'],
                              semester: f['semester'],
                              subject: f['subject'])));
                  _load();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}