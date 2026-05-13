// dashboard_page.dart
// Dashboard page to display user analytics, statistics, and activity

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart'; // For local data storage
import 'profile_page.dart'; // Import the profile page for navigation

class DashboardPage extends StatefulWidget {
  // Stateful widget for dashboard page to manage dynamic data
  const DashboardPage({super.key}); // Constructor

  @override
  _DashboardPageState createState() => _DashboardPageState(); // Create state instance
}

class _DashboardPageState extends State<DashboardPage> {
  // ============ STATE VARIABLES ============
  String? userEmail; // User's email from login
  int visitCount = 0; // Number of app visits
  String lastVisitDate = ''; // Last visit timestamp
  List<String> recentActivities = [
    'Logged in',
    'Updated profile',
    'Downloaded resume',
  ]; // Recent activities list

  // ============ LIFECYCLE METHODS ============
  @override
  void initState() {
    // Called when widget is first created
    super.initState(); // Call parent init
    _loadDashboardData(); // Load user data on page load
    _incrementVisitCount(); // Increment visit counter
  }

  // ============ DATA LOADING METHODS ============
  Future<void> _loadDashboardData() async {
    // Load email, visit count, and last visit date from SharedPreferences
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    setState(() {
      // Update state with loaded data
      userEmail = prefs.getString('user_email'); // Load user email
      visitCount =
          prefs.getInt('visit_count') ?? 0; // Load visit count or default to 0
      lastVisitDate =
          prefs.getString('last_visit') ?? 'Never'; // Load last visit date
    });
  }

  Future<void> _incrementVisitCount() async {
    // Increment and save visit count to SharedPreferences
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    visitCount =
        (prefs.getInt('visit_count') ?? 0) + 1; // Increment visit count
    await prefs.setInt('visit_count', visitCount); // Save updated count
    await prefs.setString(
      'last_visit',
      DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    ); // Save current timestamp as last visit
    setState(() {}); // Trigger UI rebuild
  }

  Future<void> _logout() async {
    // Mark user as logged out and navigate to login page
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    await prefs.setBool('is_logged_in', false); // Set login status to false
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  // ============ NAVIGATION METHODS ============
  void _navigateToProfile() {
    // Navigate to profile page
    Navigator.pushNamed(context, '/profile'); // Push profile route
  }

  void _navigateToHome() {
    // Navigate back to home page
    Navigator.pushNamed(context, '/home'); // Push home route
  }

  // ============ UI BUILD METHOD ============
  @override
  Widget build(BuildContext context) {
    // Build the dashboard UI
    final screenWidth = MediaQuery.of(
      context,
    ).size.width; // Get screen width for responsive design

    return Scaffold(
      // Main scaffold for page structure
      appBar: AppBar(
        // App bar with title and logout button
        title: const Text('Dashboard'), // Title text
        backgroundColor: Colors.blue, // Blue background
        actions: [
          // Action buttons on app bar
          IconButton(
            // Logout button
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: _logout, // Call logout function
            tooltip: 'Logout', // Tooltip on long press
          ),
        ],
      ),
      body: SafeArea(
        // SafeArea prevents content from being obscured by device UI
        child: SingleChildScrollView(
          // Allow content to scroll if too tall
          padding: const EdgeInsets.all(16), // Padding around content
          child: Column(
            // Main vertical layout
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch children to full width
            children: [
              // ===== a) Welcome Header Card =====
              Card(
                // Card widget for greeting section
                elevation: 4, // Shadow depth
                margin: const EdgeInsets.only(bottom: 20), // Space below card
                child: Padding(
                  // Add padding inside card
                  padding: const EdgeInsets.all(16), // Padding on all sides
                  child: Column(
                    // Vertical layout inside card
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to left
                    children: [
                      Text(
                        // Welcome greeting text
                        'Welcome back, ${userEmail ?? 'User'}!', // Display user email or 'User'
                        style: const TextStyle(
                          // Text styling
                          fontSize: 22, // Font size
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.blue, // Blue color
                        ),
                      ),
                      const SizedBox(height: 8), // Space between texts
                      Text(
                        // Date display
                        'Today is ${DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ), // Gray styled date
                      ),
                    ],
                  ),
                ),
              ),

              // ===== b) Stats Cards Section =====
              Padding(
                // Add padding around stats
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ), // Vertical padding
                child: Row(
                  // Horizontal layout for stat cards
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space between cards
                  children: [
                    // First stat card
                    Expanded(
                      // Make card take equal space
                      child: _buildStatCard(
                        'Visits',
                        visitCount.toString(),
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 12), // Space between cards
                    // Second stat card
                    Expanded(
                      // Make card take equal space
                      child: _buildStatCard('Profile', 'Updated', Icons.person),
                    ),
                  ],
                ),
              ),

              Padding(
                // Second row of stat cards
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ), // Vertical padding
                child: Row(
                  // Horizontal layout
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space between cards
                  children: [
                    // Third stat card
                    Expanded(
                      // Make card take equal space
                      child: _buildStatCard(
                        'Resume',
                        'Ready',
                        Icons.file_present,
                      ),
                    ),
                    const SizedBox(width: 12), // Space between cards
                    // Fourth stat card
                    Expanded(
                      // Make card take equal space
                      child: _buildStatCard(
                        'Status',
                        'Active',
                        Icons.check_circle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), // Space before next section
              // ===== c) Quick Actions Section =====
              Text(
                // Section title
                'Quick Actions', // Title text
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ), // Bold title
              ),
              const SizedBox(height: 12), // Space after title
              ElevatedButton(
                // View Profile button
                onPressed: _navigateToProfile, // Navigate to profile
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ), // Blue button
                child: const Text('View Profile'), // Button text
              ),
              const SizedBox(height: 8), // Space between buttons
              ElevatedButton(
                // Go Home button
                onPressed: _navigateToHome, // Navigate to home
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ), // Green button
                child: const Text('Back to Home'), // Button text
              ),

              const SizedBox(height: 20), // Space before next section
              // ===== d) Recent Activity Section =====
              Text(
                // Section title
                'Recent Activity', // Title text
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ), // Bold title
              ),
              const SizedBox(height: 12), // Space after title
              ListView.builder(
                // Build activity list dynamically
                shrinkWrap: true, // Don't take infinite height
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scroll (parent handles it)
                itemCount: recentActivities.length, // Number of items
                itemBuilder: (context, index) {
                  // Build each activity item
                  return _buildActivityItem(
                    recentActivities[index],
                    '2 hours ago',
                  );
                },
              ),

              const SizedBox(height: 20), // Space before next section
              // ===== e) Summary/Overview Card =====
              Card(
                // Summary card
                elevation: 4, // Shadow depth
                child: Padding(
                  // Add padding
                  padding: const EdgeInsets.all(16), // Padding on all sides
                  child: Column(
                    // Vertical layout
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to left
                    children: [
                      Text(
                        // Section title
                        'Account Summary', // Title text
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ), // Bold
                      ),
                      const SizedBox(height: 12), // Space after title
                      Row(
                        // Display status info
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space between items
                        children: [
                          const Text('Account Status:'), // Label
                          Text(
                            // Status value
                            'Active', // Status text
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ), // Green colored
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Space between rows
                      Row(
                        // Display last updated info
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space between items
                        children: [
                          const Text('Total Visits:'), // Label
                          Text(visitCount.toString()), // Display visit count
                        ],
                      ),
                      const SizedBox(height: 8), // Space between rows
                      Row(
                        // Display last visit info
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space between items
                        children: [
                          const Text('Last Visit:'), // Label
                          Text(lastVisitDate), // Display last visit date
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20), // Space before next section
              // ===== f) Footer Logout Button =====
              ElevatedButton.icon(
                // Logout button with icon
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
            ],
          ),
        ),
      ),
    );
  }

  // ============ HELPER WIDGETS ============
  Widget _buildStatCard(String title, String value, IconData icon) {
    // Reusable stat card widget for displaying metrics
    return Card(
      // Card widget for stat display
      elevation: 2, // Slight shadow
      child: Padding(
        // Add padding inside card
        padding: const EdgeInsets.all(12), // Padding on all sides
        child: Column(
          // Vertical layout
          crossAxisAlignment: CrossAxisAlignment.center, // Center align
          children: [
            Icon(icon, color: Colors.blue, size: 32), // Display icon
            const SizedBox(height: 8), // Space between icon and text
            Text(
              // Display stat title
              title, // Title parameter
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ), // Gray styled title
            ),
            const SizedBox(height: 4), // Space between title and value
            Text(
              // Display stat value
              value, // Value parameter
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), // Bold value
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String action, String timestamp) {
    // Reusable activity list item widget
    return Card(
      // Card for activity item
      margin: const EdgeInsets.only(bottom: 8), // Space below card
      child: ListTile(
        // List item with icon, title, subtitle
        leading: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ), // Green check icon
        title: Text(action), // Activity action text
        subtitle: Text(timestamp), // Timestamp text
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ), // Forward arrow icon
      ),
    );
  }
}
