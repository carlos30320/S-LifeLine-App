import 'package:american_student_book/utils/factories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String baseUrl = "student-lifeline.onrender.com";
  static var client = http.Client();

  static Future<Response> signUp(String username, String email, String password,
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
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> verifyEmail(String verificationCode) async {
    var res = await client.post(Uri.https(baseUrl, 'auth/verify-email'),
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

  static Future<Response> sendForgotPasswordRequest(String email) async {
    var res = await client
        .post(Uri.https(baseUrl, 'auth/forgot-password/send-request'),
            body: jsonEncode({
              "email": email.toString(),
            }),
            headers: {
          'Content-Type': 'application/json',
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> confirmForgotPasswordCode(
      String email, String code) async {
    var res = await client
        .post(Uri.https(baseUrl, 'auth/forgot-password/confirm-code'),
            body: jsonEncode({
              "email": email,
              "code": code,
            }),
            headers: {
          'Content-Type': 'application/json',
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> resendVerificationCode() async {
    var res = await client
        .post(Uri.https(baseUrl, 'auth/resend-verification-code'), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> udpatePassword(String password) async {
    var res = await client.put(Uri.https(baseUrl, 'auth/update-password'),
        body: jsonEncode({"password": password}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> addContact(String name, String phoneNumber) async {
    var res = await client.post(Uri.https(baseUrl, 'contacts'),
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

  static Future<Response> getSubscriptionStatus() async {
    var res = await client
        .get(Uri.https(baseUrl, 'paypal/subscription-status'), headers: {
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> subscribeForAYear() async {
    var res =
        await client.put(Uri.https(baseUrl, 'paypal/subscribe'), headers: {
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }

  static Future<Response> sendSOSSMS(location) async {
    var res = await client.post(Uri.https(baseUrl, 'contacts/send-sos-sms'),
        body: jsonEncode({"location": location.toString()}),
        headers: {
          'Authorization':
              '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
        });
    return Response.fromJson(jsonDecode(res.body));
  }

  // static Future<Response> createorder() async {
  //   var res =
  //       await client.post(Uri.https(baseUrl, '/paypal/create-order'), headers: {
  //     'Authorization':
  //         '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
  //   });
  //   print("____________________");
  //   return Response.fromJson(jsonDecode(res.body));
  // }

  // static Future completeeorder(String transactionId, String orderId) async {
  //   var res =
  //       await client.post(Uri.https(baseUrl, '/paypal/complete-order'), body: {
  //     "transactionId": transactionId,
  //     "orderId": orderId
  //   }, headers: {
  //     'Authorization':
  //         '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
  //   });

  //   return Response.fromJson(jsonDecode(res.body));
  // }
}
