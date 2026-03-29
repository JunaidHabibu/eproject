// Add Student Buttton style

import 'package:flutter/material.dart';

class AddStudent extends StatelessWidget {
  final void Function() onPressed; // takes required on pressed function

  const AddStudent({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // get app theme

    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(Icons.person_add, color: Colors.white),
      label: const Text("Add Student", style: TextStyle(color: Colors.white)),
      backgroundColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}