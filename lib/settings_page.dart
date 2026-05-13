// settings_page.dart
// Settings page for managing app preferences, security, and user account options

import 'package:flutter/material.dart'; // Flutter material design library
import 'package:shared_preferences/shared_preferences.dart'; // Local data storage

class SettingsPage extends StatefulWidget {
  // Stateful widget for settings management
  const SettingsPage({super.key}); // Constructor

  @override
  _SettingsPageState createState() => _SettingsPageState(); // Create state instance
}

class _SettingsPageState extends State<SettingsPage> {
  // ============ STATE VARIABLES ============
  bool darkMode = false; // Toggle for dark mode theme
  bool showQuotes = true; // Toggle for showing motivational quotes
  bool notificationsEnabled = true; // Toggle for push notifications
  String appVersion = '1.0.0'; // Current app version

  // ============ LIFECYCLE METHODS ============
  @override
  void initState() {
    // Called when widget is first created
    super.initState(); // Call parent init
    _loadSettings(); // Load user settings from local storage
  }

  // ============ DATA LOADING METHODS ============
  Future<void> _loadSettings() async {
    // Load all user preferences from SharedPreferences
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    setState(() {
      // Update UI with loaded settings
      darkMode = prefs.getBool('dark_mode') ?? false; // Load dark mode setting
      showQuotes = prefs.getBool('show_quotes') ?? true; // Load quotes setting
      notificationsEnabled =
          prefs.getBool('notifications') ?? true; // Load notifications setting
    });
  }

  // ============ DATA SAVING METHODS ============
  Future<void> _saveSetting(String key, dynamic value) async {
    // Save a single setting to SharedPreferences
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    if (value is bool) {
      // If value is boolean
      await prefs.setBool(key, value); // Save as bool
    } else if (value is String) {
      // If value is string
      await prefs.setString(key, value); // Save as string
    }
  }

  // ============ ACTION METHODS ============
  Future<void> _clearLocalData() async {
    // Clear all locally stored data
    showDialog(
      // Show confirmation dialog
      context: context, // Build context
      builder: (context) => AlertDialog(
        // Dialog content
        title: const Text('Clear All Data?'), // Dialog title
        content: const Text(
          // Dialog message
          'This will delete all saved preferences and settings. This action cannot be undone.',
        ),
        actions: [
          // Dialog buttons
          TextButton(
            // Cancel button
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'), // Button text
          ),
          TextButton(
            // Confirm button
            onPressed: () async {
              // Perform clear operation
              final prefs =
                  await SharedPreferences.getInstance(); // Get SharedPreferences
              await prefs.clear(); // Clear all data
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                // Show success message
                const SnackBar(
                  content: Text('All data cleared'),
                ), // Success message
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ), // Delete button
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    // Logout user and return to login page
    showDialog(
      // Show confirmation dialog
      context: context, // Build context
      builder: (context) => AlertDialog(
        // Dialog content
        title: const Text('Logout?'), // Dialog title
        content: const Text(
          'Are you sure you want to logout?',
        ), // Dialog message
        actions: [
          // Dialog buttons
          TextButton(
            // Cancel button
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'), // Button text
          ),
          TextButton(
            // Logout button
            onPressed: () async {
              // Perform logout
              final prefs =
                  await SharedPreferences.getInstance(); // Get SharedPreferences
              await prefs.setBool(
                'is_logged_in',
                false,
              ); // Set login status to false
              Navigator.pushReplacementNamed(
                context,
                '/login',
              ); // Navigate to login page
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ), // Logout button
          ),
        ],
      ),
    );
  }

  // ============ UI BUILD METHOD ============
  @override
  Widget build(BuildContext context) {
    // Build the settings page UI
    return Scaffold(
      // Main scaffold
      appBar: AppBar(
        // App bar with title
        title: const Text('Settings'), // Title text
        backgroundColor: Colors.blue, // Blue background
      ),
      body: ListView(
        // Scrollable list view
        children: [
          // ===== APPEARANCE SECTION =====
          const Padding(
            // Section header padding
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8), // Padding around text
            child: Text(
              // Section title
              'Appearance', // Section name
              style: TextStyle(
                // Text styling
                fontSize: 14, // Font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.blue, // Blue color
              ),
            ),
          ),
          SwitchListTile(
            // Dark mode toggle
            secondary: const Icon(Icons.dark_mode), // Dark mode icon
            title: const Text('Dark Mode'), // Toggle label
            subtitle: const Text('Enable dark theme'), // Description
            value: darkMode, // Current value
            onChanged: (val) {
              // When toggle changes
              setState(() => darkMode = val); // Update state
              _saveSetting('dark_mode', val); // Save to preferences
            },
          ),
          SwitchListTile(
            // Motivational quotes toggle
            secondary: const Icon(Icons.lightbulb), // Lightbulb icon
            title: const Text('Show Motivational Quotes'), // Toggle label
            subtitle: const Text('Display inspiring quotes'), // Description
            value: showQuotes, // Current value
            onChanged: (val) {
              // When toggle changes
              setState(() => showQuotes = val); // Update state
              _saveSetting('show_quotes', val); // Save to preferences
            },
          ),
          SwitchListTile(
            // Notifications toggle
            secondary: const Icon(Icons.notifications), // Bell icon
            title: const Text('Enable Notifications'), // Toggle label
            subtitle: const Text('Receive app notifications'), // Description
            value: notificationsEnabled, // Current value
            onChanged: (val) {
              // When toggle changes
              setState(() => notificationsEnabled = val); // Update state
              _saveSetting('notifications', val); // Save to preferences
            },
          ),
          const Divider(), // Horizontal separator line
          // ===== ACCOUNT SECTION =====
          const Padding(
            // Section header padding
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8), // Padding around text
            child: Text(
              // Section title
              'Account', // Section name
              style: TextStyle(
                // Text styling
                fontSize: 14, // Font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.blue, // Blue color
              ),
            ),
          ),
          ListTile(
            // Edit profile option
            leading: const Icon(Icons.person), // Person icon
            title: const Text('Edit Profile'), // Option label
            subtitle: const Text('Update name, email, bio'), // Description
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ), // Right arrow
            onTap: () {
              // When tapped
              ScaffoldMessenger.of(context).showSnackBar(
                // Show message
                const SnackBar(
                  // Message widget
                  content: Text('Profile editing coming soon'), // Message text
                ),
              );
            },
          ),
          ListTile(
            // Language option
            leading: const Icon(Icons.language), // Language icon
            title: const Text('Language'), // Option label
            subtitle: const Text('English'), // Current language
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ), // Right arrow
            onTap: () {
              // When tapped
              ScaffoldMessenger.of(context).showSnackBar(
                // Show message
                const SnackBar(
                  // Message widget
                  content: Text(
                    'Language selection coming soon',
                  ), // Message text
                ),
              );
            },
          ),
          const Divider(), // Horizontal separator line
          // ===== SECURITY SECTION =====
          const Padding(
            // Section header padding
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8), // Padding around text
            child: Text(
              // Section title
              'Security', // Section name
              style: TextStyle(
                // Text styling
                fontSize: 14, // Font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.blue, // Blue color
              ),
            ),
          ),
          ListTile(
            // Change password option
            leading: const Icon(Icons.lock), // Lock icon
            title: const Text('Change Password'), // Option label
            subtitle: const Text('Update your password'), // Description
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ), // Right arrow
            onTap: () {
              // When tapped
              ScaffoldMessenger.of(context).showSnackBar(
                // Show message
                const SnackBar(
                  // Message widget
                  content: Text('Password change coming soon'), // Message text
                ),
              );
            },
          ),
          ListTile(
            // Clear local data option
            leading: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ), // Delete icon (red)
            title: const Text('Clear Local Data'), // Option label
            subtitle: const Text('Delete all saved preferences'), // Description
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ), // Right arrow
            onTap: _clearLocalData, // Call clear data function
          ),
          const Divider(), // Horizontal separator line
          // ===== ABOUT SECTION =====
          const Padding(
            // Section header padding
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8), // Padding around text
            child: Text(
              // Section title
              'About', // Section name
              style: TextStyle(
                // Text styling
                fontSize: 14, // Font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.blue, // Blue color
              ),
            ),
          ),
          ListTile(
            // App info
            leading: const Icon(Icons.info), // Info icon
            title: const Text('About App'), // Option label
            subtitle: const Text('Portfolio App v1.0.0'), // App info
            onTap: () {
              // When tapped
              showAboutDialog(
                // Show about dialog
                context: context, // Build context
                applicationName: 'My Portfolio App', // App name
                applicationVersion: appVersion, // App version
                applicationLegalese:
                    '© 2026 NSEKO GAIN Hugue. All rights reserved.', // Copyright
              );
            },
          ),
          const SizedBox(height: 20), // Space before logout
          // ===== LOGOUT SECTION =====
          Padding(
            // Add padding around logout button
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ), // Horizontal padding
            child: ElevatedButton.icon(
              // Logout button
              onPressed: _logout, // Call logout function
              icon: const Icon(Icons.exit_to_app), // Exit icon
              label: const Text('Logout'), // Button text
              style: ElevatedButton.styleFrom(
                // Red styling for logout
                backgroundColor: Colors.red, // Red background
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ), // Button padding
              ),
            ),
          ),
          const SizedBox(height: 20), // Space at bottom
        ],
      ),
    );
  }
}
