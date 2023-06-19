import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  final String id;
  final String name;
  final String contact;
  final void Function(int) delete;

  const Contact({
    required Key key,
    required this.id,
    required this.contact,
    required this.name,
    required this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.person_rounded),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      contact,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () => delete(int.parse(id)),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
