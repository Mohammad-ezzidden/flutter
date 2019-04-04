import 'dart:async';

class EditBloc {
  final _fnameInput = StreamController<String>();
  final _lnameInput = StreamController<String>();
  final _phoneInput = StreamController<String>();
  final _emailInput = StreamController<String>();
  final _picInput = StreamController<String>();


  Sink<String> get fnameSink => _fnameInput.sink;
  Sink<String> get lnameSink => _lnameInput.sink;
  Sink<String> get phoneNumberSink => _phoneInput.sink;
  Sink<String> get emailSink => _emailInput.sink;
  Sink<String> get picSink => _picInput.sink;


  Stream<String> get fnameStream => _fnameInput.stream;
  Stream<String> get lnameStream => _lnameInput.stream;
  Stream<String> get phonenameStream => _phoneInput.stream;
  Stream<String> get emailStream => _emailInput.stream;
  Stream<String> get picStream => _picInput.stream;


  void dispose() {
    _fnameInput?.close();
    _lnameInput?.close();
    _phoneInput?.close();
    _emailInput?.close();
    _picInput?.close();
  }
}
