import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send and Receive Data to Firebase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String firebaseUrl =
      'https://nomor2-59d8b-default-rtdb.asia-southeast1.firebasedatabase.app/data.json';

  String data = '';
  TextEditingController dataController = TextEditingController();

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(firebaseUrl));
    final decodedData = jsonDecode(response.body);
    setState(() {
      data = decodedData ?? '';
    });
  }

  Future<void> sendData(String newData) async {
    final response =
        await http.put(Uri.parse(firebaseUrl), body: jsonEncode(newData));
    if (response.statusCode == 200) {
      setState(() {
        data = newData;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success'),
          content: Text('Data tersimpan.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed saving.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APK Send and Receive Data to Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data Dari Firebase:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              data,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: TextField(
                controller: dataController,
                decoration:
                    InputDecoration(labelText: 'Input data ke Firebase'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Tersimpan di Firebase'),
              onPressed: () => sendData(dataController.text),
            ),
          ],
        ),
      ),
    );
  }
}
