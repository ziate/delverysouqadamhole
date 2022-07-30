import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';
import 'package:http/http.dart' as http;

SharedPreferences sharedPreferences;
Future<bool> clearWallet({int amount, int id}) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://souqadam.com/api/v2/delivery-man/wallaet/remove?delivery_man=$id&amount$amount'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${sharedPreferences.get(AppConstants.token)}'
    },
  );
  if (response.statusCode == 200) {
    // Map data = jsonDecode(response.body);
    return true;
  } else if (response.statusCode == 500) {
    return false;
    //
  } else {
    throw Exception('status code not 200 it is ${response.statusCode}');
  }
}
