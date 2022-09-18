import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PdfViewer(),
    );
  }
}


class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {

  static Future<File> loadAssets(String path) async{
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = url.split("/").last;
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  late File file;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer (Assets)'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async{
                  const path = "assets/apps_pdf.pdf";
                  file = await loadAssets(path);
                  print(file.path);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowPDF(file: file)));
                },
                child: const Text("Show PDF"),
            ),
          ],
        ),
      ),
    );
  }
}


class ShowPDF extends StatefulWidget {
  ShowPDF({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<ShowPDF> createState() => _ShowPDFState();
}

class _ShowPDFState extends State<ShowPDF> {
  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: widget.file.path,
    );
  }
}