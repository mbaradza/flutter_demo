import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

import './bloc.dart';
import '../model/contact.dart';

class ContactBloc extends Bloc<ContactEvent, List<Contact>> {
  List<Contact> _contacts = [];
  static const platform = MethodChannel('example.channel.dev/contacts');

  @override
  List<Contact> get initialState {
    getContactList();
    return _contacts;
  }

  @override
  Stream<List<Contact>> mapEventToState(ContactEvent event) async* {
    print("event");
    if (event is Create) {
      print("create");
      var contact = Contact(event.firstName, event.lastName, event.phoneNumber);
      addContact(contact);

      _contacts.add(contact);

      yield _contacts;
    } else if (event is Delete) {
      deleteSelectedContacts(event.selectedContacts);
      event.selectedContacts.forEach((id) {
        _contacts.removeWhere((contact) => contact.id == id);
      });

      yield _contacts;
    } else if (event is Read) {
      yield _contacts;
    }
  }

//
//  method to invoke channel and add contact to database using room
  Future<void> addContact(Contact contact) async {
    print("=================================t();=============");

    var sendContact = <String, dynamic>{
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber
    };

    try {
      final String response =
          await platform.invokeMethod('saveContact', sendContact);
      print(response);
    } on PlatformException catch (e) {
      print("failed to save : '${e.message}'");
    }
  }

  Future<void> getContactList() async {
    List<dynamic> list;

    try {
      list = jsonDecode(await platform.invokeMethod('listContacts'));
    } on PlatformException catch (e) {
      print("Failed to get list of contacts:'${e.message}'");
    }

    _contacts = Contact.fromJsonDecodedMap(list);
    print(_contacts);
  }

  Future<void> deleteSelectedContacts(List<String> contactIds) async {
    var selectedContacts = <String, List<String>>{"ids": contactIds};

    try {
      String deleted =
          await platform.invokeMethod('deleteContacts', selectedContacts);
      print(deleted);
    } on PlatformException catch (e) {
      print('Failed to delete:${e.message}');
    }
  }
}
