import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../subject_tabs/materials_tab.dart';
import '../subject_tabs/notes_tab.dart';
import '../subject_tabs/attendance_tab.dart';
import '../subject_tabs/announcements_tab.dart';

class SubjectDetailPage extends StatefulWidget {
  final String username;
  final String course;
  final int semester;
  final String subject;
  const SubjectDetailPage(
      {super.key,
        required this.username,
        required this.course,
        required this.semester,
        required this.subject});

  @override
  State<SubjectDetailPage> createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadFav();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFav() async {
    final fav = await DatabaseHelper.instance.isFavorite(
        widget.username, widget.course, widget.semester, widget.subject);
    if (mounted) setState(() => _isFav = fav);
  }

  Future<void> _toggleFav() async {
    await DatabaseHelper.instance.toggleFavorite(
        widget.username, widget.course, widget.semester, widget.subject);
    _loadFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: Text(widget.subject,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.star : Icons.star_border),
            onPressed: _toggleFav,
            tooltip: 'Favorite',
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.orange.shade100,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.folder), text: 'Materials'),
            Tab(icon: Icon(Icons.notes), text: 'Notes'),
            Tab(icon: Icon(Icons.check_circle), text: 'Attendance'),
            Tab(icon: Icon(Icons.campaign), text: 'Announce'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MaterialsTab(
              username: widget.username,
              course: widget.course,
              semester: widget.semester,
              subject: widget.subject),
          NotesTab(
              username: widget.username,
              course: widget.course,
              semester: widget.semester,
              subject: widget.subject),
          AttendanceTab(
              username: widget.username,
              course: widget.course,
              semester: widget.semester,
              subject: widget.subject),
          AnnouncementsTab(
              username: widget.username,
              course: widget.course,
              semester: widget.semester,
              subject: widget.subject),
        ],
      ),
    );
  }
}