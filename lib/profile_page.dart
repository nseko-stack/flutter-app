// profile_page.dart
// This file defines the ProfilePage widget, which displays user profile information and allows logout.
// It also provides functionality to save and open a resume file from the app's assets.

import 'dart:io'; // Import Dart's IO library for file operations like reading/writing files

import 'package:flutter/material.dart'; // Import Flutter's material design library for UI components
import 'package:open_filex/open_filex.dart'; // Import package to open files with external applications
import 'package:path/path.dart'
    as p; // Import path utilities with alias 'p' for file path operations
import 'package:path_provider/path_provider.dart'; // Import package to get device directory paths
import 'package:shared_preferences/shared_preferences.dart'; // Import package for local data storage

// Define the ProfilePage as a StatefulWidget because it needs to manage dynamic state
class ProfilePage extends StatefulWidget {
  // Constructor for ProfilePage widget
  const ProfilePage({
    super.key, // Pass the key to the parent StatefulWidget class
  }); // Constructor allows this widget to be used in app navigation

  // Override the createState method to return the state object for this widget
  @override
  _ProfilePageState createState() => _ProfilePageState(); // Create and return the state instance
}

// Define the state class that manages the ProfilePage's state and behavior
class _ProfilePageState extends State<ProfilePage> {
  // Declare state variables to store user profile data
  String?
  userEmail; // Variable to store the user's email (nullable because it might not be set)
  String userName = 'NSEKO GAIN Hugue'; // Default placeholder name for the user
  String phoneNumber = '+250 782 543 693'; // Default placeholder phone number
  final String _resumeAssetPath =
      'assets/RESUME.pdf'; // Path to the resume file stored in app assets
  String?
  _savedResumePath; // Variable to store the path where resume is saved on device (nullable)

  // Getter method that returns the resume filename
  String get _resumeFileName =>
      'RESUME.pdf'; // Always returns 'RESUME.pdf' as the filename

  // Override initState method which is called when the widget is first created
  @override
  void initState() {
    super.initState(); // Call the parent class's initState method
    _loadUserData(); // Call method to load saved user data from local storage
  }

  // Method to load user profile data from SharedPreferences (local storage)
  Future<void> _loadUserData() async {
    final prefs =
        await SharedPreferences.getInstance(); // Get instance of SharedPreferences
    setState(() {
      // Update the widget's state to trigger UI rebuild
      userEmail = prefs.getString(
        'user_email',
      ); // Load email from storage, null if not found
      userName =
          prefs.getString('user_name') ?? userName; // Load name or use default
      phoneNumber =
          prefs.getString('user_phone') ??
          phoneNumber; // Load phone or use default
    });
  }

  // Method to handle user logout
  Future<void> _logout() async {
    final prefs =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    await prefs.setBool('is_logged_in', false); // Set login status to false
    Navigator.pushReplacementNamed(
      // Navigate to login page and replace current page
      context, // Build context for navigation
      '/login', // Route name for login page
    ); // Navigate back to login page
  }

  // Method to save the resume file from app assets to device storage
  Future<void> _saveResumeToDownloads() async {
    // Use try-catch to handle potential errors during file operations
    try {
      // Load the resume file from app assets as binary data
      final byteData = await DefaultAssetBundle.of(
        context,
      ).load(_resumeAssetPath);
      final bytes = byteData.buffer.asUint8List(); // Convert to byte array

      // Get the app's documents directory path
      final appDir = await getApplicationDocumentsDirectory();
      // Extract filename from asset path using path utilities
      final fileName = p.basename(_resumeAssetPath);
      // Create full destination path by combining directory and filename
      final destinationPath =
          '${appDir.path}${Platform.pathSeparator}$fileName';
      // Create File object and write the bytes to the destination
      final file = File(destinationPath);
      await file.writeAsBytes(bytes);

      // Update state to store the saved file path
      setState(() {
        _savedResumePath = destinationPath;
      });

      // Show success message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume saved to $destinationPath')),
      );
    } catch (e) {
      // Catch any errors that occur during the process
      // Show error message to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving resume: $e')));
    }
  }

  // Method to open the saved resume file
  Future<void> _openResume() async {
    // Check if resume has been saved to device first
    if (_savedResumePath == null) {
      // Show message asking user to save resume first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please save resume to device first')),
      );
      return; // Exit method early
    }

    // Create File object for the saved resume
    final file = File(_savedResumePath!);
    // Check if the file actually exists on the device
    if (!await file.exists()) {
      // Show error if file doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume file not found at $_savedResumePath')),
      );
      return; // Exit method early
    }

    // Attempt to open the file with default application
    final result = await OpenFilex.open(_savedResumePath!);
    // Check if opening was successful
    if (result.type != ResultType.done) {
      // Show error if file couldn't be opened
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the resume file')),
      );
    }
  }

  // Override the build method to define the UI structure
  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    // Return the main Scaffold widget that defines the page structure
    return Scaffold(
      // Define the app bar at the top
      appBar: AppBar(
        // Set the title text for the app bar
        title: const Text(
          'Profile', // The text to display
          style: TextStyle(fontWeight: FontWeight.bold), // Make text bold
        ), // App bar title
        // Define action buttons on the right side of app bar
        actions: [
          // Logout button with icon
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            tooltip: 'Logout', // Tooltip text shown on long press
            onPressed: _logout, // Function to call when button is pressed
          ),
        ],
      ),
      // Define the main body content
      body: SafeArea(
        // SafeArea prevents content from being obscured by device UI
        child: SingleChildScrollView(
          // Allows content to scroll if too tall
          padding: const EdgeInsets.symmetric(vertical: 24), // Vertical padding
          child: Center(
            // Center the content horizontally
            child: Container(
              // Container to constrain width and add padding
              // Set width based on screen size (responsive design)
              width: screenWidth < 600 ? screenWidth * 0.95 : 500,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ), // Horizontal padding
              child: Column(
                // Vertical layout for all content
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Stretch children to full width
                children: [
                  // List of child widgets
                  // Welcome message text
                  Text(
                    'Welcome back, ${userEmail ?? 'User'}!', // Display email or 'User' if null
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      // Define text styling
                      fontSize: 24, // Font size
                      fontWeight: FontWeight.bold, // Make text bold
                      color: Colors.blue, // Blue color
                    ),
                  ),
                  const SizedBox(height: 20), // Add vertical space
                  // Profile avatar section
                  CircleAvatar(
                    // Circular avatar widget
                    radius: 50, // Size of the circle
                    backgroundColor:
                        Colors.blue.shade100, // Light blue background
                    child:
                        userEmail !=
                            null // Conditional child based on email availability
                        ? Text(
                            // If email exists, show first letter
                            userEmail!
                                .substring(0, 1)
                                .toUpperCase(), // Get first letter uppercase
                            style: TextStyle(
                              // Style for the letter
                              fontSize: 40, // Large font size
                              color: Colors.blue.shade700, // Darker blue color
                              fontWeight: FontWeight.bold, // Bold text
                            ),
                          )
                        : Icon(
                            // If no email, show person icon
                            Icons.person, // Person icon
                            size: 50, // Icon size
                            color: Colors.blue.shade700, // Icon color
                          ),
                  ),
                  const SizedBox(height: 20), // Add vertical space
                  // Basic Info Card
                  Card(
                    // Material Design card for grouping content
                    elevation: 4, // Shadow depth
                    shape: RoundedRectangleBorder(
                      // Rounded corners
                      borderRadius: BorderRadius.circular(12), // Corner radius
                    ),
                    child: Padding(
                      // Add padding inside the card
                      padding: const EdgeInsets.all(
                        16.0,
                      ), // Padding on all sides
                      child: Column(
                        // Vertical layout inside card
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align to start
                        children: [
                          // Card content
                          // Card title
                          Text(
                            'Basic Info', // Section title
                            style: TextStyle(
                              // Title styling
                              fontSize: 18, // Font size
                              fontWeight: FontWeight.bold, // Bold text
                            ),
                          ),
                          const SizedBox(height: 16), // Space after title
                          // Individual info rows
                          _buildInfoRow(
                            // Call helper method to create info row
                            Icons.person, // Icon for the row
                            'Full Name:', // Label text
                            'NSEKO GAIN Hugue', // Value text
                          ),
                          const Divider(), // Horizontal divider line
                          _buildInfoRow(
                            // Another info row
                            Icons.email, // Email icon
                            'Email:', // Email label
                            'nsekohygue@gmail.com', // Email value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Phone info row
                            Icons.phone, // Phone icon
                            'Phone:', // Phone label
                            '+250 782 543 693', // Phone value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Location info row
                            Icons.location_on, // Location icon
                            'Location:', // Location label
                            'Kigali, Rwanda', // Location value
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between cards
                  // Professional Details Card
                  Card(
                    // Another card for professional information
                    elevation: 4, // Same elevation as previous card
                    shape: RoundedRectangleBorder(
                      // Same rounded shape
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      // Same padding
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        // Vertical layout
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card title
                          Text(
                            'Professional Details', // Section title
                            style: TextStyle(
                              // Same styling as basic info
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16), // Space after title
                          // Professional info rows
                          _buildInfoRow(
                            // Occupation row
                            Icons.work, // Work icon
                            'Occupation:', // Occupation label
                            'Software Developer | IT Specialist', // Occupation value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Company row
                            Icons.business, // Business icon
                            'Company:', // Company label
                            'Tech Solutions Ltd.', // Company value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Education row
                            Icons.school, // School icon
                            'Education:', // Education label
                            'In progress at RP University Kigali College', // Education value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Skills row
                            Icons.code, // Code icon
                            'Skills:', // Skills label
                            'Flutter, Dart, Python, JavaScript', // Skills value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Experience row
                            Icons.star, // Star icon
                            'Experience:', // Experience label
                            '2 years in software development', // Experience value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Languages row
                            Icons.language, // Language icon
                            'Languages:', // Languages label
                            'English, French', // Languages value
                          ),
                          const Divider(), // Divider
                          _buildInfoRow(
                            // Hobbies row
                            Icons
                                .phone_android, // Hobbies icon (using phone_android as placeholder)
                            'Hobbies:', // Hobbies label
                            'Coding, Traveling, Cooking', // Hobbies value
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space before resume section
                  // Resume file information display
                  Text(
                    // Label for resume file
                    'Resume file:', // Text content
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ), // Bold styling
                  ),
                  const SizedBox(height: 6), // Small space
                  Text(
                    // Display the resume filename
                    _resumeFileName, // Get filename from getter
                    style: TextStyle(color: Colors.black87), // Dark text color
                  ),
                  const SizedBox(height: 16), // Space before buttons
                  // Save Resume Button
                  ElevatedButton.icon(
                    // Button with icon and text
                    onPressed:
                        _saveResumeToDownloads, // Function to call on press
                    icon: const Icon(Icons.download), // Download icon
                    label: const Text(
                      'Save Resume to Downloads',
                    ), // Button text
                    style: ElevatedButton.styleFrom(
                      // Button styling
                      backgroundColor: Colors.green, // Green background
                      padding: const EdgeInsets.symmetric(
                        // Button padding
                        horizontal: 30, // Horizontal padding
                        vertical: 14, // Vertical padding
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), // Space between buttons
                  // Open Resume Button
                  ElevatedButton.icon(
                    // Another button with icon
                    onPressed: _openResume, // Function to open resume
                    icon: const Icon(Icons.open_in_new), // Open icon
                    label: const Text('Open Resume File'), // Button text
                    style: ElevatedButton.styleFrom(
                      // Button styling
                      backgroundColor: Colors.blue, // Blue background
                      padding: const EdgeInsets.symmetric(
                        // Same padding
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space before logout button
                  // Logout Button
                  ElevatedButton.icon(
                    // Logout button
                    onPressed: _logout, // Logout function
                    icon: const Icon(Icons.logout), // Logout icon
                    label: const Text('Logout'), // Button text
                    style: ElevatedButton.styleFrom(
                      // Red styling for logout
                      backgroundColor: Colors.red, // Red background
                      padding: const EdgeInsets.symmetric(
                        // Same padding
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create consistent info rows throughout the profile
  Widget _buildInfoRow(IconData icon, String label, String value) {
    // Return a Padding widget to add space around the row
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical padding
      child: Row(
        // Horizontal layout for icon, label, and value
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
          ), // Display the icon with blue accent color
          const SizedBox(
            width: 12,
          ), // Add horizontal space between icon and text
          Expanded(
            // Allow the text column to take remaining space
            child: Column(
              // Vertical layout for label and value
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  // Display the label text
                  label, // The label string passed as parameter
                  style: TextStyle(
                    // Style for the label
                    fontSize: 14, // Smaller font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                const SizedBox(
                  height: 4,
                ), // Small space between label and value
                Text(
                  // Display the value text
                  value, // The value string passed as parameter
                  style: TextStyle(
                    // Style for the value
                    fontSize: 16, // Regular font size
                    color: Colors.black87, // Dark gray color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
