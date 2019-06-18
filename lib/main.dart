import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'card.dart';

void main() => runApp(MyApp());

Future<List<Pharma>> getPharmas() async {
  String url = 'https://projets.maxdep.fr/niventis/api/pharmacies';
  final response = await http.get(url, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new Pharma.fromJson(m)).toList();
  } else {
    throw Exception('Impossible d\'obtenir les données');
  }
}

class Address {
  final int nbr;
  final String street;
  final String city;

  Address({this.nbr, this.street, this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        nbr: json['nbr'], street: json['street'], city: json['city']);
  }

  @override
  String toString() => '$nbr $street, $city';
}

class Pharma {
  final String id;
  final String name;
  final Address address;
  final String trainingNeed;
  final List location;

  Pharma({this.id, this.name, this.address, this.trainingNeed, this.location});

  factory Pharma.fromJson(Map<String, dynamic> json) {
    debugPrint(json['adress'].toString());
    return Pharma(
        id: json['_id'],
        name: json['name'],
        address: Address.fromJson(json['adress']),
        trainingNeed: json['trainingNeed'].toString(),
        location: json['gpsCoordinates']
    );
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
                                superDescription:
                                    pharmas[position].trainingNeed,
                                description:
                                    pharmas[position].address.toString(),
                                dialog: PharmaCardDialog(
                                  titre: pharmas[position].name,
                                  location: pharmas[position].location
                                ),
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
