import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/constants.dart';

Future<int> getQuoteIndex() async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getInt(kQuoteKey) ?? 0;
}
