import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'card.dart';

void main() => runApp(MyApp());

Future<List<Pharma>> getPharmas() async {
  String url = 'http://35.187.96.84/api/pharmacies';
  final response = await http.get(url, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new Pharma.fromJson(m)).toList();
  } else {
    throw Exception('Impossible d\'obtenir les données');
  }
}

class Pharma {
  final String id;
  final String name;

  Pharma({this.id, this.name});

  factory Pharma.fromJson(Map<String, dynamic> json) {
    return Pharma(id: json['_id'], name: json['name']);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niventis Application',
      theme: ThemeData(
        primaryColor: Colors.greenAccent,
      ),
      home: MyHomePage(title: 'Alpha Niventis V2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _position = "Aucune position";

  void getLocation() async {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((location) {
      if (location != null) {
        setState(() {
          _position = location.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '$_position',
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 474),
                  child: new FutureBuilder<List<Pharma>>(
                    future: getPharmas(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Pharma> pharmas = snapshot.data;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: pharmas.length,
                            itemBuilder: (context, position) {
                              return new PharmaCardWidget(
                                titre: pharmas[position].name,
                                icon: Icons.search,
                                superDescription: "",
                                description: pharmas[position].id,
                                dialog: null,
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: getLocation,
            tooltip: 'Location',
            child: Icon(Icons.location_searching)));
  }
}
