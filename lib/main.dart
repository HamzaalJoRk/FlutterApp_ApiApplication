import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List posts = [];

  Future<void> getData() async {
    String url = 'http://10.0.2.2:8000/api/student/result?id_student=190410420';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        //سيتم فحص responseBody باستخدام is List<dynamic> للتحقق من أنه قائمة. إذا كان
        //كذلك، يتم تحويله إلى List<Map<String, dynamic>> باستخدام cast()، وإلا سيتم
        //تحويله إلى List<Map<String, dynamic>> واحد فقط باستخدام cast().
        setState(() {
          if (responseBody is List<dynamic>) {
            posts = responseBody.cast<Map<String, dynamic>>().toList();
          } else {
            posts = [responseBody].cast<Map<String, dynamic>>();
          }
        });

        print(posts);

      } else {
        print('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white70,
          title: const Center(
            child: Text(
              'api hamza',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      body: posts == null || posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, i) {
          return Container(
              margin: EdgeInsets.all(10),
              color: Colors.white10,
              child: Text(
                'Amount Paid: ${posts[0]['data']}',
                style: TextStyle(fontSize: 20),
              ),
          );
        },
      )
    );
  }
}
