//Student Edit Page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/classes/courses.dart';
import 'package:eproject/classes/grade.dart';
import 'package:eproject/classes/student.dart';
import 'package:eproject/pages/home.dart';
import 'package:eproject/styles/sidebar.dart';
import 'package:eproject/util/getStudent.dart';
import 'package:flutter/material.dart';

class StudentEdit extends StatefulWidget {
  final Student student;

  const StudentEdit({super.key, required this.student});

  @override
  State<StudentEdit> createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _idController;
  late Grade _selectedGrade;
  late Course _selectedCourse;

  @override
  void initState() { // initalization
    super.initState();
    _firstNameController = TextEditingController(text: widget.student.firstName);
    _lastNameController  = TextEditingController(text: widget.student.lastName);
    _emailController     = TextEditingController(text: widget.student.email);
    _idController        = TextEditingController(text: widget.student.id);
    _selectedGrade       = widget.student.grade;
    _selectedCourse      = widget.student.course;
  }

  @override
  void dispose() { // dispose function to clear any connections
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void goHome() { // simple go home function
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()), // redirect to home
    );
  }

  void saveStudent() async { // save student function
  await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.student.docId) // get student through firebase doc id
        .update({ // update student data
          'firstName': _firstNameController.text.trim(),
          'lastName':  _lastNameController.text.trim(),
          'email':     _emailController.text.trim(),
          'id':        _idController.text.trim(),
          'grade':     _selectedGrade.name,
          'course':    _selectedCourse.name,
        });
  
    goHome(); // go home
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) { // helper function for building fields
    final theme = Theme.of(context);
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

  Widget _buildDropdown<T>(String label, IconData icon, T value, List<T> items, String Function(T) displayName, void Function(T?) onChanged) { // helper function for building dropdowns
    final theme = Theme.of(context);
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
  Widget build(BuildContext context) { // build UI
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar( // add topbar
        title: const Text("Edit Student"),
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

                  // avatar + name header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            "${widget.student.firstName[0]}${widget.student.lastName[0]}",
                            style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(getFullName(widget.student), style: theme.textTheme.titleMedium),
                        const SizedBox(height: 5),
                        Text(widget.student.id, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text("Personal Info", style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 12),

                  //build fields for personal info
                  _buildField("First Name", _firstNameController, Icons.person_outline),
                  _buildField("Last Name",  _lastNameController,  Icons.person_outline),
                  _buildField("Email",      _emailController,     Icons.email_outlined),
                  _buildField("Student ID", _idController,        Icons.badge_outlined),

                  const SizedBox(height: 8),

                  Text("Academic Info", style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 12),

                  //build dropdowns for academic info
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

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: saveStudent, // save student on pressed
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: goHome, // go home on pressed
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