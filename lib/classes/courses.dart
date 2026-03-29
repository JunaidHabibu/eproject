//Course class for students
//new courses can be added or removed with ease

enum Course {
  mathematics,
  science,
  english,
  history,
  biology,
  computerScience;

  String get displayName { //converting the enum names to a usable display name
    switch (this) {
      case Course.mathematics:     return "Mathematics";
      case Course.science:         return "Science";
      case Course.english:         return "English";
      case Course.history:         return "History";
      case Course.biology:         return "Biology";
      case Course.computerScience: return "Computer Science";
    }
  }
}