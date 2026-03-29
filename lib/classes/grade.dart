//Grade class for students
//new grades can be added or removed with ease

enum Grade {
  A,
  B,
  C,
  D,
  F,
  nil;

  String get displayName { //converting the enum names to a usable display name
    switch (this) {
      case Grade.A: return "A";
      case Grade.B: return "B";
      case Grade.C: return "C";
      case Grade.D: return "D";
      case Grade.F: return "F";
      case Grade.nil: return "nil";
    }
  }
}