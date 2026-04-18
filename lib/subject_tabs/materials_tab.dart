import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class MaterialsTab extends StatefulWidget {
  final String username;
  final String course;
  final int semester;
  final String subject;
  const MaterialsTab(
      {super.key,
        required this.username,
        required this.course,
        required this.semester,
        required this.subject});

  @override
  State<MaterialsTab> createState() => _MaterialsTabState();
}

class _MaterialsTabState extends State<MaterialsTab> {
  List<Map<String, dynamic>> _materials = [];

  final List<Map<String, dynamic>> _materialTypes = [
    {'type': 'PDF', 'icon': Icons.picture_as_pdf, 'color': Colors.red},
    {'type': 'Video', 'icon': Icons.video_library, 'color': Colors.blue},
    {'type': 'Image', 'icon': Icons.image, 'color': Colors.green},
    {'type': 'Notes', 'icon': Icons.description, 'color': Colors.purple},
    {'type': 'Link', 'icon': Icons.link, 'color': Colors.teal},
    {'type': 'Other', 'icon': Icons.attach_file, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    final data = await DatabaseHelper.instance.getMaterials(
        widget.username, widget.course, widget.semester, widget.subject);
    if (mounted) setState(() => _materials = data);
  }

  IconData _getIcon(String type) {
    final t = _materialTypes.firstWhere((e) => e['type'] == type,
        orElse: () => _materialTypes.last);
    return t['icon'] as IconData;
  }

  Color _getColor(String type) {
    final t = _materialTypes.firstWhere((e) => e['type'] == type,
        orElse: () => _materialTypes.last);
    return t['color'] as Color;
  }

  void _showAddMaterialDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedType = 'PDF';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        return AlertDialog(
          title: const Text('Add Study Material'),
          content: SingleChildScrollView(
            child: Column(
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
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                      labelText: 'Type', border: OutlineInputBorder()),
                  items: _materialTypes
                      .map((e) => DropdownMenuItem<String>(
                      value: e['type'] as String,
                      child: Row(children: [
                        Icon(e['icon'] as IconData,
                            color: e['color'] as Color, size: 18),
                        const SizedBox(width: 8),
                        Text(e['type'] as String),
                      ])))
                      .toList(),
                  onChanged: (v) => setS(() => selectedType = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Description / URL',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info_outline)),
                ),
              ],
            ),
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
                await DatabaseHelper.instance.addMaterial(
                    widget.username,
                    widget.course,
                    widget.semester,
                    widget.subject,
                    titleCtrl.text.trim(),
                    selectedType,
                    descCtrl.text.trim());
                Navigator.pop(ctx);
                _loadMaterials();
              },
              child:
              const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: _materials.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open,
                size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('No materials yet',
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 16)),
            const SizedBox(height: 6),
            Text('Tap + to add study materials',
                style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _materials.length,
        itemBuilder: (ctx, i) {
          final m = _materials[i];
          final color = _getColor(m['type']);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(_getIcon(m['type']), color: color),
              ),
              title: Text(m['title'],
                  style:
                  const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m['type'],
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w500)),
                  if (m['description'] != null &&
                      m['description'].toString().isNotEmpty)
                    Text(m['description'],
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  Text(_formatDate(m['created_at']),
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 11)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Delete Material'),
                      content: const Text(
                          'Are you sure you want to delete this material?'),
                      actions: [
                        TextButton(
                            onPressed: () =>
                                Navigator.pop(c, false),
                            child: const Text('Cancel')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text('Delete',
                              style:
                              TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await DatabaseHelper.instance
                        .deleteMaterial(m['id']);
                    _loadMaterials();
                  }
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: _showAddMaterialDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Material',
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