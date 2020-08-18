import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

var url =
    'https://us-central1-myna-app.cloudfunctions.net/webApi/api/v1/product_id';

Future<String> productData(String s1) async {
  var response = await http.post(url, body: {'data': s1});
  if (response.statusCode == 200) {
    var el = convert.jsonDecode(response.body);
    if (el.isEmpty == true) {
      print('body empty');
      return "";
    } else {
      print('body not empty ${el[0]['id']}');
      String srn = el[0]['id'].toString();
      return srn;
    }
  } else {
    print('error : ${response.body}');
    return "";
  }
}
