import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetAppData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // wipes all saved data
}
