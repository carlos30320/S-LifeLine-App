import 'package:american_student_book/store/store.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
   static var apiOrderId;
   static var transectionid;
  static String baseUrl = "student-lifeline.onrender.com";
  static var client = http.Client();
  static DataStore ds = DataStore.getInstance();
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

  static Future<Response> resendVerificationCode() async {
    var res = await client
        .get(Uri.https(baseUrl, 'auth/resend-verification-code'), headers: {
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

  static Future<Response> subscribeForAYear() async {
    var res = await client
        .put(Uri.https(baseUrl, 'paypal/subscribeForAYear'), headers: {
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

  static Future<Response> unsubscribe() async {
    var res = await client
        .put(Uri.https(baseUrl, 'paypal/subscribeForAYear'), headers: {
      'Authorization':
          '${await SharedPreferences.getInstance().then((value) => value.getString('access_token'))}'
    });
    return Response.fromJson(jsonDecode(res.body));
  }




  static Future createorder()async{

    var res = await client.post(Uri.https(baseUrl,'/paypal/create-order'),
        body: "",
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im5hamkiLCJpZCI6IjY0OGQ2ZDQwYTI3MTRlOTI0ZDFkODRlNiIsImlhdCI6MTY4NzAyMjI0Mn0.tjXLhGB-9w7ffrL-PRD0g9U00MCI4LYtY2KMzCwUKo4'
        });

    var saveall=jsonDecode(res.body);


    apiOrderId=saveall['data']["order"]["orderId"];
    transectionid=saveall['data']["order"]["_id"];

    print("order id: $apiOrderId");
    print("transectionid: $transectionid");





  }
   static Future completeeorder(String transectionid,String apiOrderId )async{

     var res = await client.post(Uri.https(baseUrl,'/paypal/complete-order'),
         body: {
           "transactionId": transectionid,
           "orderId": apiOrderId
         },
         headers: {
           'Content-Type': 'application/json',
           'Authorization':
           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im5hamkiLCJpZCI6IjY0OGQ2ZDQwYTI3MTRlOTI0ZDFkODRlNiIsImlhdCI6MTY4NzAyMjI0Mn0.tjXLhGB-9w7ffrL-PRD0g9U00MCI4LYtY2KMzCwUKo4'
         });

     var saveall=jsonDecode(res.body);








   }





}
