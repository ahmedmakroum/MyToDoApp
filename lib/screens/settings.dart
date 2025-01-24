import 'package:flutter/material.dart';
import 'vision.dart'; // Import the vision page

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false; // Track the theme state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Focus Mode Toggle Button
            _buildListTile(
              icon: Icons.center_focus_strong,
              title: "Focus Mode",
              subtitle: "Hide all sections except the To-Do list",
              onTap: () {
                // Add navigation or logic for Focus Mode here
              },
            ),
            Divider(),

            // Light/Dark Mode Toggle
            _buildListTile(
              icon: Icons.brightness_6,
              title: "Light/Dark Mode",
              subtitle: "Switch between light and dark themes",
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  // Apply the theme change here (for local changes or global using Provider)
                },
              ), onTap: () {  },
            ),
            Divider(),

            // Vision Boards Button
            _buildListTile(
              icon: Icons.dashboard,
              title: "Vision Boards",
              subtitle: "Monthly and Yearly vision boards",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisionBoardsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable ListTile widget for cleaner code
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
