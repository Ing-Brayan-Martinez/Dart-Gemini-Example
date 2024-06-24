import 'package:dart_gemini_example/domain/config/string_extension.dart';
import 'package:dart_gemini_example/domain/config/type_helper.dart';

final class Sqlite3Helper {
  static Integer booleanToSqlite(Boolean input) => input == true ? 1 : 0;

  static Boolean sqliteToBoolean(Integer input) => input == 1 ? true : false;

  static String dateToSqlite(DateTime input) => input.toString();

  static DateTime sqliteToDate(String input) {
    if (input.isDate()) {
      return DateTime.parse(input);
    } else {
      List<String> result = input.substring(0, 10).split('-');
      return DateTime(int.parse(result.elementAt(0)),
          int.parse(result.elementAt(1)), int.parse(result.elementAt(2)));
    }
  }
}

abstract class BaseDocument {
  List<dynamic> toListSave();

  List<dynamic> toListUpdate();
}
