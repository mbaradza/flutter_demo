import 'package:firstflutter/utils/contacts_table.dart';
import 'package:flutter/material.dart';

class ShowContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          fit: BoxFit.fitWidth,
          child: ContactsTable(),
        ),
      ],
    );
  }
}
