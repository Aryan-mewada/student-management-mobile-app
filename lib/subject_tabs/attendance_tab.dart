import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AttendanceTab extends StatefulWidget {
  final String username;
  final String course;
  final int semester;
  final String subject;
  const AttendanceTab(
      {super.key,
        required this.username,
        required this.course,
        required this.semester,
        required this.subject});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getAttendance(
        widget.username, widget.course, widget.semester, widget.subject);
    if (mounted) setState(() => _records = data);
  }

  Future<void> _mark(String status) async {
    await DatabaseHelper.instance.addAttendance(
        widget.username, widget.course, widget.semester, widget.subject, status);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final total = _records.length;
    final present =
        _records.where((r) => r['status'] == 'Present').length;
    final percent =
    total > 0 ? (present / total * 100).toStringAsFixed(1) : '0.0';
    final percentVal = total > 0 ? present / total : 0.0;

    Color percentColor = Colors.green;
    if (total > 0 && present / total < 0.75) percentColor = Colors.red;
    if (total > 0 && present / total >= 0.75 && present / total < 0.85)
      percentColor = Colors.orange;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Attendance Summary',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey.shade700)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statBox('Total', '$total', Colors.blue),
                      _statBox('Present', '$present', Colors.green),
                      _statBox('Absent', '${total - present}', Colors.red),
                      _statBox('$percent%', 'Rate', percentColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentVal.toDouble(),
                      backgroundColor: Colors.grey.shade200,
                      color: percentColor,
                      minHeight: 10,
                    ),
                  ),
                  if (total > 0 && present / total < 0.75)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber,
                              color: Colors.red, size: 16),
                          const SizedBox(width: 6),
                          Text('Attendance below 75%! Risk of debarment.',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () => _mark('Present'),
                    icon:
                    const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text('Mark Present',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () => _mark('Absent'),
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text('Mark Absent',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          Expanded(
            child: _records.isEmpty
                ? Center(
                child: Text('No records yet',
                    style:
                    TextStyle(color: Colors.grey.shade500)))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _records.length,
              itemBuilder: (ctx, i) {
                final r = _records[i];
                final isPresent = r['status'] == 'Present';
                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(
                      isPresent
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                    title: Text(r['status'],
                        style: TextStyle(
                            color: isPresent
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(_formatDate(r['date'])),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.grey, size: 18),
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .deleteAttendance(r['id']);
                        _load();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String top, String bottom, Color color) {
    return Column(
      children: [
        Text(top,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color)),
        Text(bottom,
            style:
            TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
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