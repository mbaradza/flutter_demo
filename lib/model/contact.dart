

class Contact {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;

  Contact(this.firstName, this.lastName, this.phoneNumber);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber
    };
  }

  static List<Contact> fromJsonDecodedMap(List dynamicList) {

    List<Contact> contactList = [];

    dynamicList.forEach((e) {
      Contact contact = Contact(e['firstName'], e['lastName'], e['phoneNumber']);
      contact.id = e['id'].toString();

      contactList.add(contact);
    });

    return contactList;
  }
}
