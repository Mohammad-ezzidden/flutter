import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonedailer/Blocs/EditBloc.dart';
import 'package:phonedailer/Blocs/SearchBloc.dart';
import 'package:phonedailer/Ui/Ui2.dart';
import 'package:phonedailer/Ui/pdfBuilder.dart';
import 'package:phonedailer/model/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phonedailer/Blocs/HomeBloc.dart';

class Ui1Page extends StatefulWidget {
  Ui1Page({Key key}) : super(key: key);

  @override
  _Ui1PageState createState() => _Ui1PageState();
}

class _Ui1PageState extends State<Ui1Page> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('back.jpg'), fit: BoxFit.fitHeight)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.person_add),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => NewContactPage()));
              },
            ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 20.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                      }),
                  Text(
                    'Contacts',
                    style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "t"),
                  ),
                  IconButton(
                      icon: Icon(Icons.color_lens),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Ui2Page()));
                      }),
                ],
              ),
            ),
            body: StreamBuilder<List<Contact>>(
              stream: HomeBloc.hb.allContactStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact item = snapshot.data[index];

                        return Dismissible(
                            key: UniqueKey(),
                            background: Container(color: Colors.transparent),
                            onDismissed: (direction) {
                              HomeBloc.hb.delete(item);
                            },
                            child: card1(context, item));
                      });
                } else
                  return Theme(
                      data: ThemeData(primaryColor: Colors.red),
                      child: Center(child: CircularProgressIndicator()));
              },
            )));
  }
}

Widget card1(BuildContext context, Contact contact) {
  Uint8List bytes;
  if (contact.pic != null) bytes = base64.decode(contact.pic);
  return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
      width: 400.0,
      height: 150.0,
      child: Stack(
        children: <Widget>[
          Card(
            color: Colors.transparent,
            margin: EdgeInsets.only(left: 40.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black12,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                  image: DecorationImage(
                      image: AssetImage('card.jpg'), fit: BoxFit.cover)),
            ),
          ),
          Align(
            alignment: Alignment(-0.1, 0.9),
            child: IconButton(
              color: Colors.green,
              icon: Icon(
                Icons.call,
              ),
              onPressed: () {
                launch('tel:' + contact.numberPhone);
              },
            ),
          ),
          Align(
            alignment: Alignment(0.2, 1.0),
            child: IconButton(
              icon: Icon(
                Icons.edit,
              ),
              iconSize: 24.0,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateContactPage(
                              contact: contact,
                            )));
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 100.0,
              height: 100,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 35.0,
                backgroundImage: contact.pic != null
                    ? MemoryImage(bytes)
                    : AssetImage('face.png'),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.18, -0.75),
            child: Container(
              width: 110.0,
              child: Text(
                contact.fname,
                style: TextStyle(
                    fontSize: 38.0,
                    fontFamily: "t",
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.10, -0.13),
            child: Container(
              width: 110.0,
              child: Text(
                contact.lname,
                style: TextStyle(
                    fontSize: 35.0,
                    fontFamily: "t",
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.88, 0.28),
            child: Text(
              contact.numberPhone,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "f"),
            ),
          ),
          Align(
            alignment: Alignment(1.04, -0.16),
            child: Container(
              width: 100.0,
              child: Text(
                contact.email != null ? contact.email : '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "f"),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ));
}

class UpdateContactPage extends StatefulWidget {
  Contact contact;

  UpdateContactPage({this.contact});
  _UpdateContactePageState createState() => _UpdateContactePageState();
}

class _UpdateContactePageState extends State<UpdateContactPage> {
  EditBloc editBloc;
  TextEditingController fnameController;
  TextEditingController lnameController;
  TextEditingController phoneController;
  bool fnamechange;
  bool lnamechange;
  bool phonechange;

  bool fnameIsValid;
  bool lnameIsValid;
  bool phoneIsValid;

  bool validate() {
    if (fnamechange) fnameIsValid = fnameController.text.isEmpty ? false : true;
    if (lnamechange) lnameIsValid = lnameController.text.isEmpty ? false : true;
    if (phonechange) phoneIsValid = phoneController.text.isEmpty ? false : true;
    if (fnameIsValid && lnameIsValid && phoneIsValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    editBloc = EditBloc();
    fnameController = TextEditingController();
    lnameController = TextEditingController();
    phoneController = TextEditingController();
    fnamechange = false;
    lnamechange = false;
    phonechange = false;
    fnameIsValid = true;
    lnameIsValid = true;
    phoneIsValid = true;
  }

  @override
  void dispose() {
    editBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white70),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Theme(
                data: ThemeData(primaryColor: Colors.black87),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35.0),
                    width: 400.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.black12,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                        image: DecorationImage(
                            image: AssetImage('card.jpg'), fit: BoxFit.cover)),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment(-1.3, 0.0),
                        child: Container(
                          width: 120,
                          height: 120,
                          child: StreamBuilder(
                              stream: editBloc.picStream,
                              initialData: widget.contact.pic,
                              builder: (context, snapshot) {
                                Uint8List bytes;
                                if (snapshot.data != null &&
                                    snapshot.data != '') {
                                  bytes = base64.decode(snapshot.data);
                                  return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 35.0,
                                    backgroundImage: MemoryImage(bytes),
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 35.0,
                                    backgroundImage: AssetImage('face.png'),
                                  );
                                }
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.70, -0.85),
                        child: Container(
                          width: 150.0,
                          child: StreamBuilder<String>(
                            stream: editBloc.fnameStream,
                            initialData: widget.contact.fname,
                            builder: (context, snapshot) {
                              widget.contact.fname = snapshot.data;

                              return Text(
                                snapshot.data,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 38.0,
                                    fontFamily: "t",
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.39, -0.40),
                        child: Container(
                          width: 123.0,
                          child: StreamBuilder<String>(
                              stream: editBloc.lnameStream,
                              initialData: widget.contact.lname,
                              builder: (context, snapshot) {
                                widget.contact.lname = snapshot.data;
                                return Text(
                                  snapshot.data,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 35.0,
                                      fontFamily: "t",
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                );
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.98, 0.25),
                        child: Container(
                          width: 78.0,
                          child: StreamBuilder<String>(
                              stream: editBloc.phonenameStream,
                              initialData: widget.contact.numberPhone,
                              builder: (context, snapshot) {
                                widget.contact.numberPhone = snapshot.data;
                                return Text(
                                  snapshot.data,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      letterSpacing: 0.9,
                                      fontFamily: "t"),
                                );
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment(1.04, -0.12),
                        child: Container(
                          width: 95.0,
                          child: StreamBuilder<String>(
                              stream: editBloc.emailStream,
                              initialData: widget.contact.email,
                              builder: (context, snapshot) {
                                widget.contact.email = snapshot.data;
                                return Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontFamily: "t"),
                                  maxLines: 1,
                                );
                              }),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: 172.0,
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: fnameController,
                                onChanged: (c) {
                                  fnamechange = true;
                                  editBloc.fnameSink.add(c);
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    errorText: fnameIsValid
                                        ? null
                                        : 'must not be empty',
                                    labelText: "First Name:",
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    border: OutlineInputBorder()),
                              )),
                          Container(
                            width: 177.0,
                            padding: EdgeInsets.only(left: 3),
                            child: TextField(
                              controller: lnameController,
                              onChanged: (c) {
                                lnamechange = true;
                                editBloc.lnameSink.add(c);
                              },
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  errorText:
                                      lnameIsValid ? null : 'must not be empty',
                                  labelText: "Last Name:",
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder()),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: phoneController,
                          onChanged: (c) {
                            phonechange = true;
                            editBloc.phoneNumberSink.add(c);
                          },
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              errorText:
                                  phoneIsValid ? null : 'must not be empty',
                              labelText: "Phone Number:",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (c) => editBloc.emailSink.add(c),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Email :",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RaisedButton(
                          textColor: Color.fromARGB(255, 227, 220, 207),
                          color: Colors.black87,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo_album),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Text(
                                'Pick Image',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 227, 220, 207),
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "t"),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            var image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);
                            widget.contact.pic =
                                base64.encode(image.readAsBytesSync());
                            editBloc.picSink.add(widget.contact.pic);
                          },
                        ),
                      ),
                      RaisedButton(
                        textColor: Color.fromARGB(255, 227, 220, 207),
                        color: Colors.black87,
                        child: Text('submit',
                            style: TextStyle(
                                color: Color.fromARGB(255, 227, 220, 207),
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "t")),
                        onPressed: () {
                          if (validate()) {
                            HomeBloc.hb.update(widget.contact);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ui1Page()));
                          } else {
                            setState(() {});
                          }
                        },
                      )
                    ]),
                  ),
                ]))));
  }
}

class NewContactPage extends StatefulWidget {
  NewContactPage();
  _NewContactePageState createState() => _NewContactePageState();
}

class _NewContactePageState extends State<NewContactPage> {
  EditBloc editBloc;
  TextEditingController fnameController;
  TextEditingController lnameController;
  TextEditingController phoneController;

  bool fnameIsValid;
  bool lnameIsValid;
  bool phoneIsValid;

  Contact newContact;
  bool validate() {
    fnameIsValid = fnameController.text.isEmpty ? false : true;

    lnameIsValid = lnameController.text.isEmpty ? false : true;

    phoneIsValid = phoneController.text.isEmpty ? false : true;
    if (fnameIsValid && lnameIsValid && phoneIsValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    editBloc = EditBloc();

    newContact = Contact.newC();

    fnameController = TextEditingController();
    lnameController = TextEditingController();
    phoneController = TextEditingController();

    fnameIsValid = true;
    lnameIsValid = true;
    phoneIsValid = true;
  }

  @override
  void dispose() {
    editBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white70),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Theme(
            data: ThemeData(primaryColor: Colors.black87),
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 35),
              ),
              Container(
                margin: EdgeInsets.only(left: 35.0),
                width: 400.0,
                height: 200.0,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black12,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                    image: DecorationImage(
                        image: AssetImage('card.jpg'), fit: BoxFit.cover)),
                child: Stack(children: [
                  Align(
                    alignment: Alignment(-1.3, 0.0),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: StreamBuilder(
                          stream: editBloc.picStream,
                          initialData: '',
                          builder: (context, snapshot) {
                            Uint8List bytes;
                            if (snapshot.data != null && snapshot.data != '') {
                              bytes = base64.decode(snapshot.data);
                              return CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 35.0,
                                backgroundImage: MemoryImage(bytes),
                              );
                            } else {
                              return CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 35.0,
                                backgroundImage: AssetImage('face.png'),
                              );
                            }
                          }),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.70, -0.85),
                    child: Container(
                      width: 150.0,
                      child: StreamBuilder<String>(
                        stream: editBloc.fnameStream,
                        initialData: "",
                        builder: (context, snapshot) {
                          newContact.fname = snapshot.data;

                          return Text(
                            snapshot.data,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 38.0,
                                fontFamily: "t",
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.39, -0.40),
                    child: Container(
                      width: 123.0,
                      child: StreamBuilder<String>(
                          stream: editBloc.lnameStream,
                          initialData: "",
                          builder: (context, snapshot) {
                            newContact.lname = snapshot.data;
                            return Text(
                              snapshot.data,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 35.0,
                                  fontFamily: "t",
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                            );
                          }),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.98, 0.25),
                    child: Container(
                      width: 78.0,
                      child: StreamBuilder<String>(
                          stream: editBloc.phonenameStream,
                          initialData: "",
                          builder: (context, snapshot) {
                            newContact.numberPhone = snapshot.data;
                            return Text(
                              snapshot.data,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  letterSpacing: 0.9,
                                  fontFamily: "t"),
                            );
                          }),
                    ),
                  ),
                  Align(
                    alignment: Alignment(1.04, -0.12),
                    child: Container(
                      width: 95.0,
                      child: StreamBuilder<String>(
                          stream: editBloc.emailStream,
                          initialData: "",
                          builder: (context, snapshot) {
                            newContact.email = snapshot.data;
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: "t"),
                              maxLines: 1,
                            );
                          }),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            width: 172.0,
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: fnameController,
                              onChanged: (c) {
                                editBloc.fnameSink.add(c);
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  errorText:
                                      fnameIsValid ? null : 'must not be empty',
                                  labelText: "First Name:",
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder()),
                            )),
                        Container(
                          width: 177.0,
                          padding: EdgeInsets.only(left: 3),
                          child: TextField(
                            controller: lnameController,
                            onChanged: (c) {
                              editBloc.lnameSink.add(c);
                            },
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                errorText:
                                    lnameIsValid ? null : 'must not be empty',
                                labelText: "Last Name:",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder()),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: phoneController,
                        onChanged: (c) {
                          editBloc.phoneNumberSink.add(c);
                        },
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            errorText:
                                phoneIsValid ? null : 'must not be empty',
                            labelText: "Phone Number:",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (c) => editBloc.emailSink.add(c),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email :",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RaisedButton(
                        textColor: Color.fromARGB(255, 227, 220, 207),
                        color: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.photo_album),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Text(
                              'Pick Image',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 227, 220, 207),
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "t"),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          newContact.pic =
                              base64.encode(await image.readAsBytes());
                          editBloc.picSink.add(newContact.pic);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        textColor: Color.fromARGB(255, 227, 220, 207),
                        color: Colors.black87,
                        child: Text('submit',
                            style: TextStyle(
                                color: Color.fromARGB(255, 227, 220, 207),
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "t")),
                        onPressed: () {
                          if (validate()) {
                            HomeBloc.hb.add(newContact);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ui1Page()));
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBloc mainBloc;
  List<Contact> pdfList;
  @override
  void dispose() {
    super.dispose();
    mainBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    mainBloc = SearchBloc();
    pdfList = List<Contact>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('back.jpg'), fit: BoxFit.fitHeight)),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.picture_as_pdf,
              ),
              onPressed: () {
                String inputCapture;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Export pdf :'),
                        content: Container(
                          height: 125,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'The Pdf Name '),
                                onChanged: (i) => inputCapture = i,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Export'),
                                    onPressed: () {
                                      buildPdf(inputCapture, pdfList);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
                //
              }),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 20.0,
            title: Text('Search Page'),
          ),
          body: Column(
            children: <Widget>[
              TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search for a Contact:",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder()),
                onChanged: (query) => mainBloc.query.add(query),
              ),
              Flexible(
                child: StreamBuilder<List<Contact>>(
                  stream: mainBloc.resulte,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      pdfList = snapshot.data;
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Contact item = snapshot.data[index];

                            return Dismissible(
                                key: UniqueKey(),
                                background:
                                    Container(color: Colors.transparent),
                                onDismissed: (direction) {
                                  HomeBloc.hb.delete(item);
                                },
                                child: card1(context, item));
                          });
                    } else
                      return Center(
                        child: Text(
                          'type something to get the result',
                          style: TextStyle(
                              wordSpacing: 5,
                              color: Colors.lightBlue,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "t"),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
