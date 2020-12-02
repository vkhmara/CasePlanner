import 'Note.dart';
import 'package:case_planner/WorkWithData/DatabaseManager.dart';

class TODOList {
  static List<Note> _todoList = new List();

  static Future<void> initList() async {
    await updateList();
  }

  static void addNote(Note note) {
    DatabaseManager.addNote(note);
    _todoList.add(note);
  }

  static Future<void> updateList() async {
    _todoList = await DatabaseManager.downloadAll();
  }

  Note operator[](int index) {
    return todoList[index];
  }

  static int get count {
    return _todoList.length;
  }

  static List<Note> get todoList => _todoList;

}
