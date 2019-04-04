import 'package:phonedailer/DataBase/DB.dart';
import 'package:phonedailer/model/contact.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final BehaviorSubject<List<Contact>> _allClientController =
      BehaviorSubject<List<Contact>>();

  Observable<List<Contact>> get allContactStream => _allClientController.stream;

  refreashAllContacts() async {
    _allClientController.sink.add(await DBProvider.db.getAllContact());
  }

  HomeBloc._() {
    refreashAllContacts();
  }
  static final HomeBloc hb = HomeBloc._();

  add(Contact contact) async {
    await DBProvider.db.newContact(contact);
    refreashAllContacts();
  }

  update(Contact contact) async {
    await DBProvider.db.updateContact(contact);
    refreashAllContacts();
  }

  delete(Contact contact) async {
    await DBProvider.db.delete(contact);
    refreashAllContacts();
  }
}
