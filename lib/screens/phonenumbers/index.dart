import 'package:american_student_book/components/contact.dart';
import 'package:american_student_book/layout/common_scaffold.dart';
import 'package:american_student_book/utils/api.dart';
import 'package:american_student_book/utils/factories.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    as package_phone_number;
import 'package:phone_number/phone_number.dart' as pn;

class PhoneNumbers extends StatefulWidget {
  const PhoneNumbers({super.key});
  @override
  State<PhoneNumbers> createState() => _PhoneNumbersState();
}

class PhoneNumber {
  final String id;
  final String name;
  final String phonenumber;

  PhoneNumber(
      {required this.id, required this.name, required this.phonenumber});
}

class _PhoneNumbersState extends State<PhoneNumbers> {
  var _phoneNumbers = <PhoneNumber>[];

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  String numberPre = "";
  bool canAddMoreusers = true;

  void submit() async {
    if (_nameController.value.text.isNotEmpty ||
        _numberController.value.text.isNotEmpty) {
      String formatted = await pn.PhoneNumberUtil().format(
          numberPre + _numberController.value.text, numberPre.split("+")[1]);
      Navigator.of(context).pop(PhoneNumber(
          name: _nameController.value.text.toString(),
          phonenumber: formatted,
          id: ''));

      _nameController.clear();
      _numberController.clear();
    }
  }

  Future<bool?> openConfirmDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'Delete number',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text('Are you sure you want to delete this number?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
            ],
          ));

  void delete(id) async {
    var result = await openConfirmDialog();
    if (result == true) {
      Response res = await ApiClient.deleteContact(id.toString());
      if (res.success == true) {
        _phoneNumbers.removeWhere((phoneNumber) => phoneNumber.id == id);
        setState(() {
          if (_phoneNumbers.length >= 3) {
            canAddMoreusers = false;
          } else {
            canAddMoreusers = true;
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong".toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade900,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
  }

  Future<PhoneNumber?> openDialog() => showDialog<PhoneNumber>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Add Phone Number"),
            content: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4, top: 6, left: 10),
                      child: Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8), fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 16),
                              hintText: 'Enter the name',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 06),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: package_phone_number.InternationalPhoneNumberInput(
                    inputBorder: InputBorder.none,
                    hintText: '333 444 5672',
                    inputDecoration: const InputDecoration(
                        hintText: '333 444 5672',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                    selectorConfig: const package_phone_number.SelectorConfig(
                      selectorType: package_phone_number
                          .PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    onInputChanged: (value) => {
                      numberPre = value.dialCode!,
                    },
                    initialValue:
                        package_phone_number.PhoneNumber(isoCode: 'US'),
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    textFieldController: _numberController,
                  ),
                )
              ]),
            ),
            actions: [
              TextButton(onPressed: submit, child: const Text('Add Number')),
            ],
          ));

  PhoneNumber toPhoneNumber(Map<String, dynamic> data) {
    return PhoneNumber(
      id: data['_id'],
      name: data['name'],
      phonenumber: data['phoneNumber'],
    );
  }

  Future<void> fetchContacts() async {
    Response res = await ApiClient.getContacts();
    if (res.success == true) {
      var nums = res.data['contacts'];

      setState(() {
        _phoneNumbers =
            List.generate(nums.length, (index) => toPhoneNumber(nums[index]));
      });
    } else {
      Fluttertoast.showToast(
          msg: "Aww! Something went wrong".toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade900,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      fetchContacts().then((v) => {
            isLoading = false,
            if (_phoneNumbers.length >= 3)
              canAddMoreusers = false
            else
              canAddMoreusers = true
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Phone book',
      body: Material(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      '${_phoneNumbers.length} contacts found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.7)),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _phoneNumbers.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Contact(
                            delete: delete,
                            key: ObjectKey(_phoneNumbers[i]),
                            id: _phoneNumbers[i].id,
                            contact: _phoneNumbers[i].phonenumber,
                            name: _phoneNumbers[i].name);
                      },
                    )),
                Container(
                    child: canAddMoreusers
                        ? FloatingActionButton(
                            backgroundColor: Colors.red,
                            elevation: 0,
                            child: const Icon(Icons.person_add),
                            onPressed: () async {
                              if (_phoneNumbers.length != 3) {
                                final newnumber = await openDialog();
                                Response res = await ApiClient.addContact(
                                    newnumber!.name, newnumber.phonenumber);
                                if (res.success == true) {
                                  print("asdfasdfasdfasdfasdf ${res.data}");
                                  var thisNumber = PhoneNumber(
                                      id: res.data['_id'],
                                      name: res.data['name'],
                                      phonenumber: res.data['phoneNumber']);
                                  setState(() => _phoneNumbers.add(thisNumber));
                                  setState(() {
                                    if (_phoneNumbers.length < 3) {
                                      canAddMoreusers = true;
                                    } else {
                                      canAddMoreusers = false;
                                    }
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: res.message.toString(),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red.shade900,
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                }
                              }
                            })
                        : const Text(
                            "You can save no more than three phone numbers.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
