// home_page.dart
// This is the landing page after login.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart'; // Import the dashboard page for navigation
import 'profile_page.dart'; // Import the profile page for navigation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load saved email from local storage
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString(
        'user_email',
      ); // Retrieve stored email from local storage
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'is_logged_in',
      false,
    ); // Mark user as logged out, but keep credentials saved
    Navigator.pushReplacementNamed(
      context,
      '/login',
    ); // Navigate back to login page
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Logout button in app bar
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: screenWidth < 600 ? screenWidth * 0.9 : 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, ${userEmail ?? 'User'}!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Navigation cards
              Card(
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text("Profile"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/profile',
                    ); // Navigate to profile page
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.dashboard, color: Colors.green),
                  title: Text("Dashboard"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/dashboard',
                    ); // Navigate to dashboard page
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.orange),
                  title: Text("Settings"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/settings',
                    ); // Navigate to settings page
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
