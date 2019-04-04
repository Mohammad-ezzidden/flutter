import 'package:phonedailer/DataBase/DB.dart';
import 'package:phonedailer/model/contact.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  Observable<List<Contact>> _resulte = Observable.empty();

  PublishSubject<String> _query = PublishSubject();

  Observable<List<Contact>> get resulte => _resulte;
  Sink<String> get query => _query.sink;

  SearchBloc() {
    _resulte = _query.distinct().asyncMap(DBProvider.db.getSearchResulte);
  }

  void dispose() {
    _query.close();
  }
}
