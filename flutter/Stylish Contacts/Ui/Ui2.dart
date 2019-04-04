import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:phonedailer/Blocs/EditBloc.dart';
import 'package:phonedailer/Blocs/SearchBloc.dart';
import 'package:phonedailer/Blocs/HomeBloc.dart';
import 'package:phonedailer/Ui/Ui1.dart';
import 'package:phonedailer/Ui/pdfBuilder.dart';
import 'package:phonedailer/model/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flip_card/flip_card.dart';
import 'package:image_picker/image_picker.dart';

class Ui2Page extends StatefulWidget {
  Ui2Page({Key key}) : super(key: key);

  @override
  _Ui2PageState createState() => _Ui2PageState();
}

class _Ui2PageState extends State<Ui2Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 244, 240, 229),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.person_add,
              color: Color.fromARGB(255, 244, 240, 229),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NewContactPage2()));
            },
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    color: Color.fromARGB(255, 26, 45, 52),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage2()));
                    }),
                Text(
                  'Contacts',
                  style: TextStyle(
                      color: Color.fromARGB(255, 26, 45, 52),
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "t"),
                ),
                IconButton(
                    color: Color.fromARGB(255, 26, 45, 52),
                    icon: Icon(Icons.color_lens),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Ui1Page()));
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

                      return card2(context, item);
                    });
              } else
                return Center(
                  child: Theme(
                    data: ThemeData(accentColor: Colors.black87),
                    child: CircularProgressIndicator(),
                  ),
                );
            },
          ),
        ));
  }
}

Widget card2(BuildContext context, Contact contact) {
  Uint8List bytes;
  if (contact.pic != null) bytes = base64.decode(contact.pic);
  return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Color.fromARGB(255, 244, 240, 229),
      ),
      onDismissed: (direction) {
        HomeBloc.hb.delete(contact);
      },
      child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(left: 20, right: 15),
          width: 320.0,
          height: 195.0,
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 160,
                width: 400,
                child: FlipCard(
                  direction: FlipDirection.VERTICAL,
                  back: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 244, 240, 229),
                        image: DecorationImage(
                            image: AssetImage('card3.jpg'), fit: BoxFit.fill)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.phone_iphone,
                                color: Color.fromARGB(255, 227, 220, 207),
                              ),
                              Text(
                                  contact.numberPhone != null
                                      ? contact.numberPhone
                                      : '',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 244, 240, 229),
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "t")),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 244, 240, 229),
                                ),
                                Text(
                                  contact.email != null ? contact.email : '',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 244, 240, 229),
                                      fontSize: 25.0,
                                      fontFamily: "t"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  front: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 244, 240, 229),
                        image: DecorationImage(
                            image: AssetImage('card3.jpg'), fit: BoxFit.fill)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 35.0,
                            backgroundImage: contact.pic != null
                                ? MemoryImage(bytes)
                                : AssetImage('face.jpg'),
                          ),
                          Text(contact.fname != null ? contact.fname : '',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 244, 240, 229),
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "t")),
                          Text(
                            contact.lname != null ? contact.lname : '',
                            style: TextStyle(
                                color: Color.fromARGB(255, 244, 240, 229),
                                fontSize: 25.0,
                                fontFamily: "t"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  color: Color.fromARGB(255, 225, 77, 67),
                  onPressed: () {
                    launch('tel:' + contact.numberPhone);
                  },
                  icon: Icon(
                    Icons.call,
                  ),
                ),
                IconButton(
                  color: Colors.red[400],
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateContactPage2(contact: contact)));
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                )
              ],
            ),
          ])));
}

class UpdateContactPage2 extends StatefulWidget {
  Contact contact;

  UpdateContactPage2({this.contact});
  _UpdateContactePageState2 createState() => _UpdateContactePageState2();
}

class _UpdateContactePageState2 extends State<UpdateContactPage2> {
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
        padding: EdgeInsets.only(top: 25),
        decoration: BoxDecoration(color: Color.fromARGB(255, 244, 240, 229)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Theme(
            data: ThemeData(primaryColor: Colors.black87),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      child: StreamBuilder(
                          stream: editBloc.picStream,
                          initialData: widget.contact.pic,
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
                                backgroundImage: AssetImage('face2.png'),
                              );
                            }
                          }),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Color.fromARGB(255, 244, 240, 229),
                        width: 400.0,
                        height: 80.0,
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 140,
                              width: 400,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 244, 240, 229),
                                    image: DecorationImage(
                                        image: AssetImage('card3.jpg'),
                                        fit: BoxFit.contain)),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: editBloc.fnameStream,
                                          initialData: widget.contact.fname,
                                          builder: (context, snapshot) {
                                            widget.contact.fname =
                                                snapshot.data;
                                            return Text(snapshot.data,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 244, 240, 229),
                                                    fontSize: 28.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "t"));
                                          }),
                                      StreamBuilder(
                                          stream: editBloc.lnameStream,
                                          initialData: widget.contact.lname,
                                          builder: (context, snapshot) {
                                            widget.contact.lname =
                                                snapshot.data;
                                            return Text(
                                              snapshot.data,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 244, 240, 229),
                                                  fontSize: 25.0,
                                                  fontFamily: "t"),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])),
                    Container(
                      width: 400.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 240, 229),
                          image: DecorationImage(
                              image: AssetImage('card3.jpg'),
                              fit: BoxFit.scaleDown)),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone_iphone,
                                  color: Color.fromARGB(255, 227, 220, 207),
                                ),
                                StreamBuilder(
                                    stream: editBloc.phonenameStream,
                                    initialData: widget.contact.numberPhone,
                                    builder: (context, snapshot) {
                                      widget.contact.numberPhone =
                                          snapshot.data;
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 227, 220, 207),
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "t"));
                                    })
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 227, 220, 207),
                                ),
                                StreamBuilder(
                                    stream: editBloc.emailStream,
                                    initialData: widget.contact.email,
                                    builder: (context, snapshot) {
                                      widget.contact.email = snapshot.data;
                                      return Text(
                                        snapshot.data,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 227, 220, 207),
                                            fontSize: 25.0,
                                            fontFamily: "t"),
                                      );
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
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
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                      errorText: lnameIsValid
                                          ? null
                                          : 'must not be empty',
                                      labelText: "Last Name:",
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                          Container(
                              width: 100,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: RaisedButton(
                                      textColor:
                                          Color.fromARGB(255, 227, 220, 207),
                                      color: Colors.black87,
                                      child: Text(
                                        'pick image',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 227, 220, 207),
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "t"),
                                      ),
                                      onPressed: () async {
                                        var image = await ImagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        widget.contact.pic = base64
                                            .encode(await image.readAsBytes());
                                        editBloc.picSink
                                            .add(widget.contact.pic);
                                      },
                                    ),
                                  ),
                                  RaisedButton(
                                      textColor:
                                          Color.fromARGB(255, 227, 220, 207),
                                      color: Colors.black87,
                                      child: Text(
                                        'submit',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 227, 220, 207),
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "t"),
                                      ),
                                      onPressed: () {
                                        if (validate()) {
                                          HomeBloc.hb.update(widget.contact);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Ui2Page()));
                                        } else {
                                          setState(() {});
                                        }
                                      }),
                                ],
                              ))
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}

class SearchPage2 extends StatefulWidget {
  SearchPage2({Key key}) : super(key: key);

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  SearchBloc searchBloc;
  List<Contact> pdfList;
  @override
  void dispose() {
    super.dispose();
    searchBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchBloc = SearchBloc();
    pdfList = List<Contact>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 227, 220, 207)),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.picture_as_pdf,
                color: Color.fromARGB(255, 26, 45, 52),
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
                              Theme(
                                data: ThemeData(primaryColor: Colors.black87),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'The Pdf Name '),
                                  onChanged: (i) => inputCapture = i,
                                ),
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
            title: Text('search Page'),
          ),
          body: Column(
            children: <Widget>[
              Theme(
                data: ThemeData(primaryColor: Colors.black87),
                child: TextField(
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Search for a Contact:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder()),
                  onChanged: (query) => searchBloc.query.add(query),
                ),
              ),
              Flexible(
                child: StreamBuilder<List<Contact>>(
                  stream: searchBloc.resulte,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      pdfList = snapshot.data;
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Contact contact = snapshot.data[index];

                            return Dismissible(
                                key: UniqueKey(),
                                background: Container(color: Colors.redAccent),
                                onDismissed: (direction) {
                                  HomeBloc.hb.delete(contact);
                                },
                                child: card2(context, contact));
                          });
                    } else
                      return Center(child: Text('Search for acontact'));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class NewContactPage2 extends StatefulWidget {
  NewContactPage2();
  _NewContactePageState2 createState() => _NewContactePageState2();
}

class _NewContactePageState2 extends State<NewContactPage2> {
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
        padding: EdgeInsets.only(top: 25),
        decoration: BoxDecoration(color: Color.fromARGB(255, 244, 240, 229)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Theme(
            data: ThemeData(primaryColor: Colors.black87),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
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
                                backgroundImage: AssetImage('face2.png'),
                              );
                            }
                          }),
                    ),
                    Container(
                        color: Color.fromARGB(255, 244, 240, 229),
                        width: 400.0,
                        height: 80.0,
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 140,
                              width: 400,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 244, 240, 229),
                                    image: DecorationImage(
                                        image: AssetImage('card3.jpg'),
                                        fit: BoxFit.contain)),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: editBloc.fnameStream,
                                          initialData: '',
                                          builder: (context, snapshot) {
                                            newContact.fname = snapshot.data;
                                            return Text(snapshot.data,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 244, 240, 229),
                                                    fontSize: 28.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "t"));
                                          }),
                                      StreamBuilder(
                                          stream: editBloc.lnameStream,
                                          initialData: '',
                                          builder: (context, snapshot) {
                                            newContact.lname = snapshot.data;
                                            return Text(
                                              snapshot.data,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 244, 240, 229),
                                                  fontSize: 25.0,
                                                  fontFamily: "t"),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 400.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 240, 229),
                          image: DecorationImage(
                              image: AssetImage('card3.jpg'),
                              fit: BoxFit.scaleDown)),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone_iphone,
                                  color: Color.fromARGB(255, 244, 240, 229),
                                ),
                                StreamBuilder(
                                    stream: editBloc.phonenameStream,
                                    initialData: '',
                                    builder: (context, snapshot) {
                                      newContact.numberPhone = snapshot.data;
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 244, 240, 229),
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "t"));
                                    })
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 244, 240, 229),
                                ),
                                StreamBuilder(
                                    stream: editBloc.emailStream,
                                    initialData: '',
                                    builder: (context, snapshot) {
                                      newContact.email = snapshot.data;
                                      return Text(
                                        snapshot.data,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 244, 240, 229),
                                            fontSize: 25.0,
                                            fontFamily: "t"),
                                      );
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
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
                                        errorText: fnameIsValid
                                            ? null
                                            : 'must not be empty',
                                        labelText: "First Name:",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                      errorText: lnameIsValid
                                          ? null
                                          : 'must not be empty',
                                      labelText: "Last Name:",
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                          Container(
                            width: 150,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: RaisedButton(
                                    textColor:
                                        Color.fromARGB(255, 227, 220, 207),
                                    color: Colors.black87,
                                    child: Text(
                                      'pick image',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 227, 220, 207),
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "t"),
                                    ),
                                    onPressed: () async {
                                      var image = await ImagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      newContact.pic = base64
                                          .encode(await image.readAsBytes());
                                      editBloc.picSink.add(newContact.pic);
                                    },
                                  ),
                                ),
                                RaisedButton(
                                  textColor: Color.fromARGB(255, 227, 220, 207),
                                  color: Colors.black87,
                                  child: Text(
                                    'submit',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 227, 220, 207),
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "t"),
                                  ),
                                  onPressed: () {
                                    if (validate()) {
                                      HomeBloc.hb.add(newContact);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Ui2Page()));
                                    } else {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
