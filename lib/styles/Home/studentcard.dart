//Studnet card stule

import 'package:eproject/classes/student.dart';
import 'package:eproject/util/getStudent.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final Student student; // required student class
  final void Function() onEdit; // required on edit function
  final void Function() onDelete; // required on delete function

  const StudentCard({super.key, required this.student, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // get app theme

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            getFullName(student)[0], // helper function to get students full name
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          getFullName(student),  // helper function to get students full name
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "ID: ${student.id} · Grade: ${student.grade.displayName}", // display the student id and thier grade next to it
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Edit Button
            IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: onEdit, // call on edit function passed from argument on edit
            ),

            //Delete Button
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: onDelete, // call on edit function passed from argument on delete
            ),
          ],
        ),
      ),
    );
  }
}