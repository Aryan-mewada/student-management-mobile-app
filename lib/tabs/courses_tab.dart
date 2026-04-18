import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../pages/subject_detail_page.dart';

class CoursesTab extends StatefulWidget {
  final String username;
  const CoursesTab({super.key, required this.username});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  String selectedLevel = 'Bachelor';
  String selectedCourse = 'BCA';
  int selectedSemester = 1;

  final Map<String, List<String>> courses = {
    'Bachelor': ['BCA', 'B.Com', 'BBA', 'B.Sc Computer Science', 'B.Tech'],
    'Master': ['MCA', 'M.Com', 'MBA', 'M.Sc Computer Science', 'M.Tech'],
    '5 Years (Integrated)': ['M.Sc Computer Science (5 Years)'],
  };

  final Map<String, Map<int, List<String>>> courseSubjects = {
    'BCA': {
      1: ['C Programming', 'Maths I'],
      2: ['Data Structures', 'DBMS'],
      3: ['Java', 'Operating System'],
      4: ['Python', 'Web Development'],
      5: ['AI Basics', 'Software Engineering'],
      6: ['Final Project', 'Mobile App Dev'],
    },
    'B.Com': {
      1: ['Accountancy I', 'Business Economics'],
      2: ['Accountancy II', 'Business Law'],
      3: ['Banking & Finance', 'Cost Accounting'],
      4: ['Company Law', 'Auditing'],
      5: ['Income Tax', 'Marketing'],
      6: ['Indirect Tax', 'Project Work'],
    },
    'BBA': {
      1: ['Principles of Management', 'Business Comm.'],
      2: ['Organizational Behavior', 'Human Resource'],
      3: ['Managerial Economics', 'Financial Mgmt'],
      4: ['Operations Mgmt', 'Marketing Research'],
      5: ['Strategic Mgmt', 'Entrepreneurship'],
      6: ['International Business', 'Major Project'],
    },
    'B.Sc Computer Science': {
      1: ['Computer Fundamentals', 'Physics I'],
      2: ['Programming in C++', 'Physics II'],
      3: ['Data Structures', 'Electronics'],
      4: ['Database Systems', 'Computer Networks'],
      5: ['Software Engineering', 'PHP/MySQL'],
      6: ['Cloud Computing', 'Mini Project'],
    },
    'B.Tech': {
      1: ['Engineering Physics', 'Eng. Maths I'],
      2: ['Engineering Chemistry', 'Eng. Maths II'],
      3: ['Digital Electronics', 'Discrete Maths'],
      4: ['Computer Architecture', 'Algorithms'],
      5: ['Microprocessors', 'Theory of Computation'],
      6: ['Compiler Design', 'Graphics'],
    },
    'MCA': {
      1: ['Advanced Java', 'Networking'],
      2: ['Machine Learning', 'Advanced DBMS'],
      3: ['Cloud Computing', 'Cyber Security'],
      4: ['Big Data Analytics', 'Internship'],
    },
    'M.Com': {
      1: ['Managerial Accounting', 'Stats for Business'],
      2: ['Corporate Finance', 'Investment Mgmt'],
      3: ['E-Commerce', 'Financial Markets'],
      4: ['Business Environment', 'Dissertation'],
    },
    'MBA': {
      1: ['Business Strategy', 'Ethics'],
      2: ['Consumer Behavior', 'Supply Chain'],
      3: ['Portfolio Management', 'Retail'],
      4: ['Leadership', 'Corporate Governance'],
    },
    'M.Sc Computer Science': {
      1: ['Distributed Systems', 'Cryptography'],
      2: ['Data Warehousing', 'Parallel Computing'],
      3: ['Natural Language Processing', 'IoT'],
      4: ['Research Methodology', 'Final Thesis'],
    },
    'M.Tech': {
      1: ['Advanced Algorithms', 'Soft Computing'],
      2: ['Neural Networks', 'Embedded Systems'],
      3: ['Specialization Elective I', 'Seminar'],
      4: ['Project Work Phase II'],
    },
    'M.Sc Computer Science (5 Years)': {
      1: [
        'Indic Knowledge System',
        'Language & Literature',
        'Fundamentals Of Computer & Programming',
        'Digital Electronics For Computer Science',
        'Mathematical Foundation',
        'Programming Skills - Practical',
        'Open Source Software - Practical',
        'Front End Web Development - Practical',
        'Office Tools For Professional - Practical',
      ],
      2: [
        'Literature & Language',
        'Environment Studies',
        'Advanced Programming',
        'Database Management System',
        'Computer Oriented Statistical Methods',
        'Advanced Programming - Practical',
        'Database Management System - Practical',
        'Computer Oriented Statistical Methods - Practical',
        'Website Development - Practical',
      ],
      3: [
        'Indian Knowledge System',
        'English For Excellence',
        'Data Structures With Object Oriented Programming',
        'Computer Oriented Numerical Methods',
        'Fundamentals Of Networking',
        'Data Structures With Object Oriented Programming - Practical',
        'Computer Oriented Numerical Methods - Practical',
        'Python Programming - Practical',
      ],
      4: [
        'Stress Management',
        'English For Excellence - II',
        'System Software',
        'Database Management System - II',
        'Web Application Development',
        'Web Framework - Practical',
        'Web Scripting - Practical',
        'WAD - Practical & DBMS - II - Practical',
      ],
      5: [
        'Java Programming',
        'Artificial Intelligence',
        'Machine Learning',
        'Data Analytics',
        'Java Programming - Practical',
        'Artificial Intelligence - Practical',
        'Data Analytics - Practical',
        'Advanced Python Programming - Practical',
      ],
      6: [
        'Operating Systems',
        'Object Oriented Analysis & Design',
        'Computer Vision',
        'Hindi',
        'Mobile Application Development - Practical',
        'Computer Vision - Practical',
        'Internship - Practical',
      ],
      7: [
        'Big Data Analytics',
        'Network Security',
        'Cloud Computing',
        'Internet of Things',
        'Big Data Analytics - Practical',
        'Network Security - Practical',
        'Cloud Computing - Practical',
      ],
      8: [
        'Data Science',
        'Mobile Computing',
        'Deep Learning',
        'Software Project Management',
        'Data Science - Practical',
        'Mobile Computing - Practical',
        'Mini Project',
      ],
      9: [
        'Major Project Phase - I',
        'Research Methodology',
        'Seminar',
        'Project Phase - I Review',
      ],
      10: [
        'Major Project Phase - II',
        'Final Thesis',
        'Viva Voce',
        'Project Dissertation Submission',
      ],
    },
  };

  List<int> getSemesters() {
    if (selectedLevel == '5 Years (Integrated)') {
      return List.generate(10, (i) => i + 1);
    } else if (selectedLevel == 'Bachelor') {
      return [1, 2, 3, 4, 5, 6];
    } else {
      return [1, 2, 3, 4];
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = courseSubjects[selectedCourse]?[selectedSemester] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedLevel,
                    decoration: const InputDecoration(
                        labelText: 'Select Degree',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school, color: Colors.orange)),
                    items: courses.keys
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedLevel = v!;
                        selectedCourse = courses[v]!.first;
                        selectedSemester = 1;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCourse,
                    decoration: const InputDecoration(
                        labelText: 'Select Course',
                        border: OutlineInputBorder(),
                        prefixIcon:
                        Icon(Icons.menu_book, color: Colors.orange)),
                    items: courses[selectedLevel]!
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedCourse = v!;
                        selectedSemester = 1;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedSemester,
                    decoration: const InputDecoration(
                        labelText: 'Select Semester',
                        border: OutlineInputBorder(),
                        prefixIcon:
                        Icon(Icons.calendar_today, color: Colors.orange)),
                    items: getSemesters()
                        .map((e) => DropdownMenuItem(
                        value: e, child: Text('Semester $e')))
                        .toList(),
                    onChanged: (v) {
                      setState(() => selectedSemester = v!);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (subjects.isNotEmpty) ...[
            Text('Subjects (${subjects.length})',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...subjects.map((subject) => SubjectCard(
              username: widget.username,
              course: selectedCourse,
              semester: selectedSemester,
              subject: subject,
            )),
          ],
        ],
      ),
    );
  }
}


class SubjectCard extends StatefulWidget {
  final String username;
  final String course;
  final int semester;
  final String subject;
  const SubjectCard(
      {super.key,
        required this.username,
        required this.course,
        required this.semester,
        required this.subject});

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFav();
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.subject, color: Colors.orange),
        ),
        title: Text(widget.subject,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${widget.course} • Sem ${widget.semester}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(_isFav ? Icons.star : Icons.star_border,
                  color: _isFav ? Colors.amber : Colors.grey),
              onPressed: _toggleFav,
              tooltip: 'Favorite',
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubjectDetailPage(
              username: widget.username,
              course: widget.course,
              semester: widget.semester,
              subject: widget.subject,
            ),
          ),
        ),
      ),
    );
  }
}