import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/bloc.dart';
import './view/add_contact.dart';
import './view/show_contacts.dart';
import 'bloc/contact_bloc.dart';

void main() => runApp(ContactsApp());

class ContactsApp extends StatefulWidget{

  @override
  State createState() {
return _ContactsApp();
  }
}

class _ContactsApp extends State<ContactsApp> {
  final ContactBloc _contactBloc = ContactBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          accentColor: Colors.deepOrangeAccent,
          primarySwatch: Colors.deepPurple),
      home: BlocProvider<ContactBloc>(
        builder: (context)=>_contactBloc,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Phonebook'),
              bottom: TabBar(tabs: <Widget>[
                Tab(
                  text: 'Add Contact',
                  icon: Icon(Icons.create),
                ),
                Tab(
                  text: 'Contacts',
                  icon: Icon(Icons.contacts),
                ),
              ]),
            ),
            body: TabBarView(children: <Widget>[AddContact(), ShowContacts()]),
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {
    _contactBloc.dispose();
    super.dispose();

  }


}
