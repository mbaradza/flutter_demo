import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view/add_contact.dart';
import '../model/contact.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/contact_event.dart';


class ContactsTable extends StatefulWidget {
  @override
  State createState() {
    return _ContactsTable();
  }
}


class _ContactsTable extends State<ContactsTable> {
  static const platform = MethodChannel('example.channel.dev/contacts');
  ContactBloc _contactBloc;

  List<Contact> _contacts;
  List<String> selectedContacts;
  bool sort;


  @override
  void initState() {
    _contactBloc = BlocProvider.of<ContactBloc>(context);
    _contactBloc.dispatch(Read());
    sort = false;
    selectedContacts = [];
    super.initState();
  }





  sortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      ascending
          ? _contacts.sort((a, b) => a.firstName.compareTo(b.firstName))
          : _contacts.sort((a, b) => b.firstName.compareTo(a.firstName));
    }
  }

  selectedRow(bool selected, String contactId) async{
    setState(() {
      selected
          ? selectedContacts.add(contactId)
          : selectedContacts.remove(contactId);
    });
  }

  deleteSelected() async{
    confirmDialog(context).then((bool value) async{


      if(value && selectedContacts.isNotEmpty) {
        setState((){
          _contactBloc.dispatch(Delete(selectedContacts: selectedContacts));

        });
      }



    });



  }

  DataTable tableContents() {
    return DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        columns: [
          DataColumn(
              label: Text('FIRST NAME'),
              tooltip: "First Name of  contact ",
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  sortColumn(columnIndex, ascending);
                });
              }),
          DataColumn(
              label: Text('LAST NAME'),
              tooltip: "Last Name of  contact ",
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                  sortColumn(columnIndex, ascending);
                });
              }),
          DataColumn(
            label: Text('PHONENUMBER'),
            tooltip: "contact's phonenumber ",
          ),
        ],
        rows: _contacts
            .map(
              (contact) => DataRow(
              selected: selectedContacts.isEmpty
                  ? false
                  : selectedContacts.contains(contact.id),
              onSelectChanged: (b) {
                selectedRow(b, contact.id);

              },
              cells: [
                DataCell(Text(contact.firstName)),
                DataCell(
                  Text(contact.lastName),
                ),

                DataCell(
                  Text(contact.phoneNumber),
                ),
              ]),
        )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(bloc: _contactBloc, builder:(BuildContext context, List<Contact> contacts){
      _contacts = contacts;
      print("==============================here");
      print(_contacts);
      return Container(
        child:SingleChildScrollView(child:Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            tableContents(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: OutlineButton(child: Text('SELECTED ${selectedContacts.length}'),onPressed: (){

                  }),
                ), Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FloatingActionButton(child: Icon(Icons.delete_forever),onPressed: selectedContacts.isEmpty ? null : (){
                    deleteSelected();



                  }),
                )
              ],
            ),
          ],
        ),
        ),);

    });
  }
}

Future<bool> confirmDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ), FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}