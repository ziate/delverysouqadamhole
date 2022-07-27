import 'package:sixvalley_delivery_boy/data/http/api.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';

Future<Map> fund({String input, String token}) async {
  API api = API();
  Map response = await api
      .postRequest(url: AppConstants.fundURI, body: {'query': input, '': ''});
}
