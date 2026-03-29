//Student class 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eproject/classes/courses.dart';
import 'package:eproject/classes/grade.dart';

//every single student created uses this student class
//new student values can be added or removed easily
//any changes made to the student class require appropriate changes to the rest of the app (UI, datastore, etc)

class Student {
  String docId; // firestore document ID
  String id; //student id
  String firstName;
  String lastName;
  String email;
  Grade grade;
  Course course;

  Student({ //creating a new student will require the following values
    this.docId = '',
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.grade,
    required this.course,
  });

  // converting firestore document to Student
  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      docId: doc.id,
      firstName: data['firstName'] ?? '',
      lastName:  data['lastName']  ?? '',
      id:        data['id']        ?? '',
      email:     data['email']     ?? '',
      grade:     Grade.values.firstWhere((g) => g.name == data['grade'],  orElse: () => Grade.nil),
      course:    Course.values.firstWhere((c) => c.name == data['course'], orElse: () => Course.mathematics),
    );
  }

  // converting student to firestore map
  Map<String, dynamic> toFirestore() => {
    'firstName': firstName,
    'lastName':  lastName,
    'id':        id,
    'email':     email,
    'grade':     grade.name,
    'course':    course.name,
  };

  //the firestore must match the same order in which the student values are shown or else things will break
}