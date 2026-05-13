//login_page.dart
// This file defines the LoginPage widget, which is a stateful widget that represents the login screen of the application.
// It uses local storage (shared_preferences) to authenticate users instead of Firebase.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences for local storage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState(); // Create the state for the login page
}

class _LoginPageState extends State<LoginPage> {
  final _formKey =
      GlobalKey<
        FormState
      >(); // Tracks the state of the form for validation purposes
  final _emailController =
      TextEditingController(); // Controller for the email input field
  final _passwordController =
      TextEditingController(); // Controller for the password input field

  //Login function called when user pressed Login using local storage
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final prefs =
          await SharedPreferences.getInstance(); // Get shared preferences instance
      final storedEmail = prefs.getString(
        'user_email',
      ); // Retrieve stored email
      final storedPassword = prefs.getString(
        'user_password',
      ); // Retrieve stored password

      if (storedEmail == _emailController.text &&
          storedPassword == _passwordController.text.trim()) {
        // Check if credentials match stored ones
        await prefs.setBool('is_logged_in', true); // Set login status to true
        print(
          "Login successful with email: ${_emailController.text}",
        ); // Print success message
        // Navigate to home page after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("Login failed: Invalid credentials");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    }
  }

  @override // Override the build method to define the UI of the login page
  Widget build(BuildContext context) {
    // Build the UI of the login page
    final screenwidth = MediaQuery.of(
      context,
    ).size.width; // Get the width of the screen for responsive design
    return Scaffold(
      backgroundColor:
          Colors.white, // Set the background color of the login page
      body: Center(
        child: Container(
          width: screenwidth < 600
              ? screenwidth * 0.9
              : 400, // Set the width of the container based on screen size for responsiveness
          padding: const EdgeInsets.all(24), // inner padding for the container
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color of the container
            borderRadius: BorderRadius.circular(
              12,
            ), // Set the border radius for rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ], // Add a shadow effect to the container
          ),
          child: Form(
            key: _formKey, // connects the form to the _formKey for validation
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Minimize the vertical space taken by the column
              children: [
                Text(
                  'Welcome back!', // Title text for the login page
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ), // Style for the title text
                ),
                const SizedBox(
                  height: 24,
                ), // Add vertical spacing between the title and the email field
                // Email input field
                TextFormField(
                  controller:
                      _emailController, // Connect the email input field to its controller
                  decoration: InputDecoration(
                    labelText: 'Email', // Label for the email input field
                    border:
                        OutlineInputBorder(), // Add an outline border to the email input field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required"; // Validation message if the email field is empty
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      // Regular expression to validate the email format
                      return "Please enter a valid email address"; // Validation message if the email format is invalid
                    }
                    return null; // Return null if the email is valid
                  },
                ),
                const SizedBox(
                  height: 16,
                ), // Add vertical spacing between the email and password fields
                // Password input field with validation
                TextFormField(
                  controller:
                      _passwordController, // Connect the password input field to its controller
                  obscureText: true, // Hide the text for password input
                  decoration: InputDecoration(
                    labelText: "Password", // Label for the password input field
                    prefixIcon: Icon(
                      Icons.lock,
                    ), // Add a lock icon to the password input field
                    border:
                        OutlineInputBorder(), // Add an outline border to the password input field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required"; // Validation message if the password field is empty
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters"; // Validation message if the password is too short
                    }
                    return null; // Return null if the password is valid
                  },
                ),
                const SizedBox(
                  height: 24,
                ), // Add vertical spacing between the password field and the login button
                // Login button
                SizedBox(
                  width: double
                      .infinity, // make the button take the full width of the container
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .blueAccent, // Set the background color of the login button
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ), // Set the vertical padding for the login button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Set the border radius for the login button
                      ),
                    ),
                    child: Text(
                      "Login", // Text for the login button
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ), // Style for the login button text
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ), // Add vertical spacing between the login button and the signup prompt
                // signup link
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/signup',
                    ); // Navigate to the signup page when the button is pressed
                  },
                  child: Text(
                    "Don't have an account? Sign up", // Text for the signup prompt
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ), // Set the color of the signup prompt text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
