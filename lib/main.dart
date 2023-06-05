import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:generates_random_people_data/MyHttpOverrides.dart';
import 'package:http/http.dart' as http;

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(RandomPeopleApp());
}

class RandomPeopleApp extends StatefulWidget {
  @override
  _RandomPeopleAppState createState() => _RandomPeopleAppState();
}

class _RandomPeopleAppState extends State<RandomPeopleApp> {
  List<dynamic> peopleData = [];

  Future<void> fetchRandomPeople() async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        peopleData = jsonData['results'];
      });
    } else {
      print('Failed to fetch people data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRandomPeople();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random People Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Random People Generator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: fetchRandomPeople,
                child: Text('Reset'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: peopleData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final person = peopleData[index];
                    return Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${person['name']['first']} ${person['name']['last']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Email: ${person['email']}'),
                          SizedBox(height: 10),
                          Text('Gender: ${person['gender']}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
