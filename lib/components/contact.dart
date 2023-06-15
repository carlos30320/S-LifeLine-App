import 'package:american_student_book/store/store.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  String id;
  String name;
  String contact;
  void Function(dynamic int) delete;
  Contact(
      {super.key,
      required this.id,
      required this.contact,
      required this.name,
      required this.delete});

  DataStore ds = DataStore.getInstance();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.blueGrey.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(Icons.person_rounded)),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            contact,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () => delete(id),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ))
                ]),
          ),
        ),
      ),
    );
  }
}
