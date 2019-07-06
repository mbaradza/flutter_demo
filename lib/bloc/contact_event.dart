import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class ContactEvent extends Equatable{
  ContactEvent([List props = const []]) : super(props);

}

class Create extends ContactEvent{

final String firstName;
final String lastName;
final String phoneNumber;

Create({@required this.firstName, @required this.lastName, @required this.phoneNumber}): super([firstName,lastName,phoneNumber]);

@override
String toString() {
  return 'Create{firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber}';
}


}

class Read extends ContactEvent{

  @override
  String toString() {
    return 'Read{}';
  }
}

class Delete extends ContactEvent{
  final List<String> selectedContacts;

  Delete({@required this.selectedContacts}):super([selectedContacts]);

  @override
  String toString() {
    return 'Delete{}';
  }
}