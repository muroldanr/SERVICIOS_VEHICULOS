import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final File? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState(path);
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  File? path;
  _PDFScreenState(this.path);
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getPath();
  }

  _getPath() {
    print("SOY EL PATH EN EL PAGE PDF: " + path.toString());
    print("SOY EL PATH EN EL PAGE DEL PATH  PDF: " + path!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path!.path.substring(56, path!.path.length)),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: path!.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
            },
          ),
        ],
      ),
    );
  }
}
