import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
import 'signup_page.dart'; // Import the signup page
import 'home_page.dart'; // Import the home page
import 'profile_page.dart'; // Import the profile page
import 'dashboard_page.dart'; // Import the dashboard page
import 'settings_page.dart'; // Import the settings page
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences for local storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  final prefs =
      await SharedPreferences.getInstance(); // Get shared preferences instance
  final bool isLoggedIn =
      prefs.getBool('is_logged_in') ?? false; // Check if user is logged in
  runApp(
    MyApp(initialRoute: isLoggedIn ? '/home' : '/login'),
  ); // Set initial route based on login status
}

class MyApp extends StatelessWidget {
  final String initialRoute; // Initial route parameter

  const MyApp({
    super.key,
    required this.initialRoute,
  }); // Constructor with initial route

  @override // Override the build method to define the UI of the application
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login and Signup', // Set the title of the application
      theme: ThemeData(
        primarySwatch:
            Colors.blue, // Set the primary color theme of the application
      ),
      initialRoute: initialRoute, // Set the initial route dynamically
      routes: {
        '/login': (context) => LoginPage(), // Define route for login page
        '/signup': (context) => SignupPage(), // Define route for signup page
        '/home': (context) => HomePage(), // Define route for home page
        '/profile': (context) => ProfilePage(), // Define route for profile page
        '/dashboard': (context) =>
            DashboardPage(), // Define route for dashboard page
        '/settings': (context) =>
            const SettingsPage(), // Define route for settings page
      },
    );
  }
}
