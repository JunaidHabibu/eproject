// The main homepage of the student management system

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/classes/student.dart';
import 'package:eproject/pages/studentCreate.dart';
import 'package:eproject/pages/studentEdit.dart';
import 'package:eproject/styles/Home/addstudent.dart';
import 'package:eproject/styles/Home/serchbar.dart';
import 'package:eproject/styles/sidebar.dart';
import 'package:eproject/styles/Home/studentcard.dart';
import 'package:eproject/util/getStudent.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic>? userData; // getting the user data (form either login-in or session tracking)
  const Home({super.key, this.userData});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Student> students = []; //table of all avaliable student
  List<Student> filtered = []; //table of all filtered student (this table is the main one used and it is required for the searchbar to work)

  bool _isLoading = true; //start loading

  @override
  void initState() { //state initalization
    super.initState();
    loadStudents(); // loading the students
  }

Future<void> loadStudents() async { // getting every student from the firestore and loading them in
  try {
    QuerySnapshot snapshot = await _firestore.collection('students').get();
    print('Docs found: ${snapshot.docs.length}'); // how many docs were found
    setState(() {
      students = snapshot.docs.map((doc) => Student.fromFirestore(doc)).toList(); //adding all found students to the students table
      filtered  = students; // setting the filtered tables values to the students table values
      _isLoading = false; // stop loading
    });
  } catch (e) { // catches and gets any errors found during student loading
    print('Error loading students: $e'); // what error was gotten
    setState(() => _isLoading = false); // stop loading
  }
}

  void search(String query) { // main search function
    setState(() {
      filtered = students
          .where((s) => s.firstName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }); // filters through the filtered students table checking for which one that matches the first name
  }

  void createStudent() async { // creating students
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentCreate()), // redirection to the student create page
    );
    loadStudents(); // refresh after returning
  }

  void editStudent(Student student) async { // edit student
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentEdit(student: student)), // redirection to the student edit page
    );
    loadStudents(); // refresh after returning
  }

  void deleteStudent(Student student) { // delete student
    final theme = Theme.of(context); // getting the app theme

    showDialog( // confirmation dialouge pop up
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text("Confirmation", style: theme.textTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to delete student profile", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 15),
            Text(getFullName(student), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton( // cancel button
            onPressed: () => Navigator.pop(context), // exit confirmation dialouge
            child: Text("Cancel", style: TextStyle(color: theme.textTheme.bodySmall?.color)),
          ),
          TextButton( // confirm button
            onPressed: () async {
              Navigator.pop(context); // exit confirmation dialouge
              await _firestore.collection('students').doc(student.docId).delete(); // delete the student doc from the firestore
              loadStudents(); // refresh students
            },
            child: Text("Confirm", style: TextStyle(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) { // ui building
    final theme = Theme.of(context); // get app theme

    return Scaffold(
      appBar: AppBar( // app topbar 
        title: Text("Student Management", style: theme.textTheme.titleMedium),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),

      // create student floating action button
      floatingActionButton: AddStudent(onPressed: createStudent), // gets AddStudent button style taking on pressed argument as create student

      body: Row( // main body
        children: [
          HomeSidebar(), // creates the sidebar

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Searchbar(onChanged: search), //calls search function on search bar changes

                  const SizedBox(height: 15),

                  Expanded(
                    child: _isLoading // check if is loading
                        ? const Center(child: CircularProgressIndicator()) // if loading create circular progress bar
                        : filtered.isEmpty // if the table is empty
                            ? Center(child: Text("No students found", style: theme.textTheme.bodyMedium)) //display no students
                            : ListView.builder( // build a new list of students
                                itemCount: filtered.length, // cap total card count to max number of students in filtered table
                                itemBuilder: (context, index) { // build student cards
                                  return StudentCard( // create student card
                                    student: filtered[index], // get student
                                    
                                    //student edit and delete buttons on student card passing in the current student as an argument
                                    onEdit: () => editStudent(filtered[index]),
                                    onDelete: () => deleteStudent(filtered[index]),
                                  );
                                },
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