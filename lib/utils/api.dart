import 'package:american_student_book/store/store.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String baseUrl = "asb-api.onrender.com";
  static var client = http.Client();
  static DataStore ds = DataStore.getInstance();
  static Future<Response> SignUp(String username, String email, String password,
      String confirmPassword) async {
    var response = await client.post(Uri.https(baseUrl, 'auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": username.toString(),
          "email": email.toString(),
          "password": password.toString(),
          "confirmPassword": confirmPassword.toString()
        }));

    var body = jsonDecode(response.body);
    Response res = Response.fromJson(body);
    return res;
  }

  static Future<Response> signIn(String email, String password) async {
    var res = await client.post(Uri.https(baseUrl, 'auth/signin'),
        body: jsonEncode({
          "email": email.toLowerCase().toString(),
          "password": password.toString()
        }),
        headers: {'Content-Type': 'application/json'});
    print(res);
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> verifyEmail(String verificationCode) async {
    var res = await client.post(Uri.https(baseUrl, 'auth/verifyEmail'),
        body: jsonEncode({
          "verificationCode": verificationCode.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> resendVerificationCode() async {
    var res = await client.get(Uri.https(baseUrl, 'auth/resendVerificationCode'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> addContact(String name, String phoneNumber) async {
    var res = await client.post(Uri.https(baseUrl, 'contacts/new'),
        body: jsonEncode(
            {"name": name.toString(), "phoneNumber": phoneNumber.toString()}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> deleteContact(String id) async {
    var res = await client
        .delete(Uri.https(baseUrl, 'contacts/${id.toString()}'), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> getContacts() async {
    var res = await client.get(Uri.https(baseUrl, 'contacts'), headers: {
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> subscribeForAYear() async {
    var res = await client
        .put(Uri.https(baseUrl, 'paypal/subscribeForAYear'), headers: {
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> unsubscribe() async {
    var res = await client
        .put(Uri.https(baseUrl, 'paypal/subscribeForAYear'), headers: {
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }
}
