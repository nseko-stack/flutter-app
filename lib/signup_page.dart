// signup_page.dart
// This file defines the SignupPage widget, which is a stateful widget that represents the signup page of the application.
// It uses local storage (shared_preferences) to store user credentials instead of Firebase.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences for local storage

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState(); // Create the state for the signup page
}

class _SignupPageState extends State<SignupPage> {
  final _formKey =
      GlobalKey<
        FormState
      >(); // Tracks the state of the form for validation purposes
  final _emailController =
      TextEditingController(); // Controller for the email input field
  final _passwordController =
      TextEditingController(); // Controller for the password input field
  final _confirmPasswordController =
      TextEditingController(); // Controller for the confirm password input field

  // Function called when user pressed Signup using local storage
  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      final prefs =
          await SharedPreferences.getInstance(); // Get shared preferences instance
      final existingEmail = prefs.getString(
        'user_email',
      ); // Check if user already exists

      if (existingEmail != null) {
        // If user already exists, show error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User already exists')));
        return;
      }

      // Save user credentials
      await prefs.setString('user_email', _emailController.text);
      await prefs.setString('user_password', _passwordController.text.trim());
      await prefs.setBool('is_logged_in', true); // Set login status to true

      print(
        "Signup successful with email: ${_emailController.text}",
      ); // Print success message
      // Navigate to home page after successful signup
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(
      context,
    ).size.width; // Get the width of the screen for responsive design
    return Scaffold(
      backgroundColor:
          Colors.white, // Set the background color of the signup page
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
                  'Create Account', // Title text for the signup page
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ), // Style for the title text
                ),
                const SizedBox(height: 24), // Add vertical spacing
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
                      return 'Please enter your email'; // Validation message if email is empty
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 16,
                ), // Add vertical spacing between the email and password fields
                // Password input field
                TextFormField(
                  controller:
                      _passwordController, // Connect the password input field to its controller
                  decoration: InputDecoration(
                    labelText: 'Password', // Label for the password input field
                    border:
                        OutlineInputBorder(), // Add an outline border to the password input field
                  ),
                  obscureText: true, // Hide the password text for security
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password'; // Validation message if password is empty
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 16,
                ), // Add vertical spacing between the password and confirm password fields
                // Confirm password input field
                TextFormField(
                  controller:
                      _confirmPasswordController, // Connect the confirm password input field to its controller
                  decoration: InputDecoration(
                    labelText:
                        'Confirm Password', // Label for the confirm password input field
                    border:
                        OutlineInputBorder(), // Add an outline border to the confirm password input field
                  ),
                  obscureText:
                      true, // Hide the confirm password text for security
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password'; // Validation message if confirm password is empty
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match'; // Validation message if passwords do not match
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                const SizedBox(
                  height: 24,
                ), // Add vertical spacing between the confirm password field and the signup button
                // Signup button
                SizedBox(
                  width: double
                      .infinity, // Make the button take the full width of the container
                  child: ElevatedButton(
                    onPressed:
                        _signup, // Call the _signup function when the button is pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .blueAccent, // Set the background color of the signup button
                    ),
                    child: Text(
                      'Sign Up',
                    ), // Text displayed on the signup button
                  ),
                ),
                const SizedBox(
                  height: 16,
                ), // Add vertical spacing between the signup button and the login link
                // Link to navigate back to the login page
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/login',
                    ); // Navigate to the login page when the link is pressed
                  },
                  child: Text(
                    'Already have an account? Log in',
                  ), // Text displayed on the login link
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
