import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();
  static LocalStorageService? _instance;
  static LocalStorageService get to => _instance ??= LocalStorageService._();

  static const String _userDataKey = "gitPathDataKey";

  void clear() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void setPathData(String path) async {
    var prefs = await SharedPreferences.getInstance();
    String list = prefs.getString(_userDataKey) ?? "";
    list += "||" + path;
    prefs.setString(_userDataKey, list);
  }

  Future<List<String>> getPathData() async {
    var prefs = await SharedPreferences.getInstance();    
    var data = prefs.get(_userDataKey);
    if(data == null) return <String>[];
    return data.toString().split("||");
  }

  void removePathData() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(_userDataKey);
  }
}