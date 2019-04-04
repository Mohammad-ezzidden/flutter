import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:phonedailer/model/contact.dart';

void buildPdf(String fileName, List<Contact> contactsList) async {
  final pdf = Document(deflate: zlib.encode);
  List<List<String>> finaly = new List<List<String>>();
  finaly.add(['First Name', 'Last Name', 'Phone Number', 'Email']);

  for (int i = 0; i < contactsList.length; i++) {
    finaly.add(contactsList[i].toList());
  }

  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) return null;
        return Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColor.grey)),
            child: Text(fileName,
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColor.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text("Page ${context.pageNumber}",
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColor.grey)));
      },
      build: (Context context) {
        return <Widget>[
          Header(
              level: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(fileName, textScaleFactor: 2.0),
                    PdfLogo()
                  ])),
          Table.fromTextArray(context: context, data: finaly),
          Padding(padding: EdgeInsets.all(10)),
        ];
      }));

  Directory docDir = await getExternalStorageDirectory();
  String docPath = docDir.path;
  var file = File("$docPath/$fileName.pdf");
  await file.writeAsBytes(pdf.document.save());
}
