import 'package:flutter/material.dart';
import '../pages/subject_detail_page.dart';

class SearchTab extends StatefulWidget {
  final String username;
  const SearchTab({super.key, required this.username});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _results = [];

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
  };

  void _search(String query) {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    final q = query.toLowerCase();
    final List<Map<String, dynamic>> found = [];
    for (final course in courseSubjects.entries) {
      for (final semEntry in course.value.entries) {
        for (final subject in semEntry.value) {
          if (subject.toLowerCase().contains(q) ||
              course.key.toLowerCase().contains(q)) {
            found.add({
              'subject': subject,
              'course': course.key,
              'semester': semEntry.key,
            });
          }
        }
      }
    }
    setState(() => _results = found);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _ctrl,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Search subjects or courses...',
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              suffixIcon: _ctrl.text.isNotEmpty
                  ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _ctrl.clear();
                    _search('');
                  })
                  : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Colors.orange, width: 2)),
            ),
            onChanged: _search,
          ),
        ),
        if (_results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${_results.length} results found',
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
        Expanded(
          child: _results.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search,
                    size: 70, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('Search for any subject',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 16)),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _results.length,
            itemBuilder: (ctx, i) {
              final r = _results[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFF3E0),
                    child:
                    Icon(Icons.subject, color: Colors.orange),
                  ),
                  title: Text(r['subject'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      '${r['course']} • Sem ${r['semester']}',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: Colors.grey),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectDetailPage(
                        username: widget.username,
                        course: r['course'],
                        semester: r['semester'],
                        subject: r['subject'],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}