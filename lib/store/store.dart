import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumber {
  String name;
  String phonenumber;
  String? id;

  PhoneNumber({this.id, required this.name, required this.phonenumber});
  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
        id: json['_id'], name: json['name'], phonenumber: json['phoneNumber']);
  }
}

class Location {
  String? latitude;
  String? longitude;

  Location({this.latitude, this.longitude});

  bool isSet() {
    return latitude != null && longitude != null;
  }

  void set(String lat, String long) {
    latitude = lat;
    longitude = long;
  }

  void clear() {
    latitude = null;
    longitude = null;
  }
}

class DataStore {
  _DataStore() {}

  Location location = Location();

  String name = "James";
  String email = "james@gmail.com";

  List<PhoneNumber> phoneNumbers = [];

  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static DataStore? _singleton;
  bool addNumber(PhoneNumber newNumber) {
    phoneNumbers.add(newNumber);
    return true;
  }

  String getUsername() {
    init();
    return prefs!.getString('username')!;
  }

  bool removeNumber(String id) {
    phoneNumbers = phoneNumbers.where((element) => element.id != id).toList();
    return true;
  }

  static DataStore getInstance() {
    _singleton ??= DataStore();
    return _singleton!;
  }

  static Future<bool> isContactNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isUserNew'));
    bool? isNew = prefs.getBool('isUserNew');
    return isNew == null || isNew == true ? true : false;
  }

  static Future<void> setIsContactNew(bool isNew) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isUserNew'));
    await prefs.setBool('isUserNew', isNew);
  }
}
