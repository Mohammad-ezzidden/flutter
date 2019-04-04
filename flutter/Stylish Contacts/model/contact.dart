class Contact {
  int id;
  String fname, lname, numberPhone, email, pic;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      '_id': id,
      'fname': fname,
      'lname': lname,
      'numberPhone': numberPhone,
      'email': email != null ? email : '',
      'pic': pic != null ? pic : ''
    };
    return map;
  }

  Contact(this.fname, this.lname, this.numberPhone,
      {this.id, this.email, this.pic});

  Contact.newC();

  Contact.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    fname = map['fname'];
    lname = map['lname'];
    numberPhone = map['numberPhone'];

    email = map['email'];

    pic = map['pic'];
  }

  List<String> toList() {
    List<String> result = List<String>();
    result.add(fname);
    result.add(lname);
    result.add(numberPhone);
    result.add(email);
    return result;
  }
}
