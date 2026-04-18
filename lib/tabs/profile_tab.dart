import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final String username;
  final String email;
  const ProfileTab(
      {super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.orange,
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(username,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(email,
              style:
              TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileRow(Icons.person, 'Username', username),
                  const Divider(),
                  _profileRow(Icons.email, 'Email', email),
                  const Divider(),
                  _profileRow(
                      Icons.verified_user, 'Account Status', 'Active'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App Features',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _featureRow(Icons.folder, 'Study Materials',
                      'Add PDFs, Videos, Links per subject'),
                  _featureRow(Icons.notes, 'Notes',
                      'Write & edit notes per subject'),
                  _featureRow(Icons.check_circle, 'Attendance Tracker',
                      'Track present/absent with % stats'),
                  _featureRow(Icons.campaign, 'Announcements',
                      'Post important announcements'),
                  _featureRow(Icons.star, 'Favorites',
                      'Star subjects for quick access'),
                  _featureRow(Icons.search, 'Search',
                      'Search any subject or course'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          )
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}