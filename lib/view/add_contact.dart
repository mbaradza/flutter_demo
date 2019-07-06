import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contact_bloc.dart';
import '../bloc/contact_event.dart';
import '../model/contact.dart';

class AddContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddContactDetails();
}

class AddContactDetails extends State<AddContact> {
  static const platform = MethodChannel('example.channel.dev/contacts');
  final _formKey = GlobalKey<FormState>();

  String firstName, lastName, phoneNumber;

  Future<void> addContact(Contact contact) async {
    print("==============================================");

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

  @override
  Widget build(BuildContext context) {
    final ContactBloc _contactBloc = BlocProvider.of<ContactBloc>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    validator: (value) {
                      return value.isEmpty ? 'Enter some text' : null;
                    },
                    onSaved: (value) => setState(() {
                          firstName = value;
                        }),
                    decoration: InputDecoration(
                        labelText: 'Enter your FirstName',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) {
                    return value.isEmpty ? 'Enter some text' : null;
                  },
                  onSaved: (value) => setState(() {
                        lastName = value;
                      }),
                  decoration: InputDecoration(
                      labelText: 'Enter your LastName',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) {
                    return value.isEmpty ? 'Enter some text' : null;
                  },
                  onSaved: (value) => setState(() {
                        phoneNumber = value;
                      }),
                  decoration: InputDecoration(
                      labelText: 'Enter your PhoneNumber',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  keyboardType: TextInputType.phone,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _contactBloc.dispatch(Create(
                            firstName: firstName,
                            lastName: lastName,
                            phoneNumber: phoneNumber));

                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Contact saved')));
                      }
                    },
                    tooltip: 'Save',
                    child: new Icon(Icons.add),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
