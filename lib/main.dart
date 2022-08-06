import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;
  int total = 0;

  void onClick() async {
    File file = await _downloadFile();
    final archive = ZipDecoder().decodeBytes(
      file.readAsBytesSync(),
    );
    for (var file in archive.files) {
      if (file.isFile) {
        try {
          print(file.name);
        } catch (e) {
          rethrow;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$count/ $total',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onClick,
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ),
    );
  }

  Future<File> _downloadFile() async {
    var dir = await getApplicationDocumentsDirectory();
    var req = await Dio(BaseOptions(responseType: ResponseType.bytes)).get(
        "https://github.com/lokhandeyogesh7/ScormSamples/raw/master/COVID-19-Awareness-2.zip",
        onReceiveProgress: (count, total) {
      setState(() {
        this.count = count;
        this.total = total;
      });
    });
    var file = File('${dir.path}/COVID-19-Awareness-2.zip.zip');
    return file.writeAsBytes(req.data);
  }
}
