// Student Create page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/classes/courses.dart';
import 'package:eproject/classes/grade.dart';
import 'package:eproject/pages/home.dart';
import 'package:eproject/styles/sidebar.dart';
import 'package:flutter/material.dart';

class StudentCreate extends StatefulWidget {
  const StudentCreate({super.key});

  @override
  State<StudentCreate> createState() => _StudentCreateState();
}

class _StudentCreateState extends State<StudentCreate> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _emailController     = TextEditingController();

  Grade  _selectedGrade  = Grade.nil;
  Course _selectedCourse = Course.mathematics;

  @override
  void dispose() { // dispose function for cleaning up instances and preventing memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void goHome() { // simple go home function
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()), // redirect to home page
    );
  }

  String generateStudentId() { // generate student id function
    final now = DateTime.now();
    final suffix = now.millisecondsSinceEpoch % 10000; // get the last 5 digits
    return 'STU$suffix';
  }

  void createStudent() async { // create student function
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) return; // check if theres no values in the first and last name controllers
  
    await FirebaseFirestore.instance.collection('students').add({ // add a new student to the students firestore
      'firstName': _firstNameController.text.trim(),
      'lastName':  _lastNameController.text.trim(),
      'email':     _emailController.text.trim(),
      'id': generateStudentId(),
      'grade':     _selectedGrade.name,
      'course':    _selectedCourse.name,
    });
  
    goHome();
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) { // helper function to build text fields
    final theme = Theme.of(context); // geting the  app theme
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, IconData icon, T value, List<T> items, String Function(T) displayName, void Function(T?) onChanged) { // helper function to build dropdowns
    final theme = Theme.of(context); // geting the  app theme
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        dropdownColor: theme.cardColor,
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(displayName(item)),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) { // build ui
    final theme = Theme.of(context); // get app theme

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Student"),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        elevation: 0,
      ),

      body: Row(
        children: [
          HomeSidebar(), // create sidebar

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Avatar
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        Text("New Student", style: theme.textTheme.titleMedium),
                        const SizedBox(height: 5),
                        Text("Fill in the details below", style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Personal Info
                  Text("Personal Info", style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 12),

                  _buildField("First Name", _firstNameController, Icons.person_outline),
                  _buildField("Last Name",  _lastNameController,  Icons.person_outline),
                  _buildField("Email",      _emailController,     Icons.email_outlined),

                  const SizedBox(height: 8),

                  // Academic Info
                  Text("Academic Info", style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 12),

                  _buildDropdown<Grade>(
                    "Grade", Icons.grade_outlined,
                    _selectedGrade, Grade.values,
                    (g) => g.displayName,
                    (val) => setState(() => _selectedGrade = val!),
                  ),

                  _buildDropdown<Course>(
                    "Course", Icons.book_outlined,
                    _selectedCourse, Course.values,
                    (c) => c.displayName,
                    (val) => setState(() => _selectedCourse = val!),
                  ),

                  const SizedBox(height: 36),

                  // Create button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: createStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const Text("Create Student", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: goHome,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.textTheme.bodySmall?.color ?? Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: Text("Cancel", style: TextStyle(fontSize: 16, color: theme.textTheme.bodySmall?.color)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}