import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'formu.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niventis Application',
      theme: ThemeData(
        primaryColor: Colors.greenAccent,
      ),
      home: MyHomePage(
        title: 'Alpha Niventis V2',
        storage: new PharmasStorage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final PharmasStorage storage;
  final String title;

  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _filter = new TextEditingController();
  ScaffoldState scaffold;
  String _searchText = "";
  List<Formu> pharmas;
  List<Formu> filterPharmas;
  String _position = "Aucune position";
  double _positionLong;
  double _positionLatt;
  bool pharmasPersist = false;
  bool notifDisplay = false;

  _MyHomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filterPharmas = pharmas;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
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
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: _filter,
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
                  child: new FutureBuilder<List<Formu>>(
                    future: Formu.getPharmas(_positionLong, _positionLatt),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        pharmas = snapshot.data;
                        if (!pharmasPersist) {
                          print("Pharma persist");
                          print(widget.storage.writePharmas(pharmas));
                          pharmasPersist = true;
                          if (pharmas == null) {
                            SchedulerBinding.instance.addPostFrameCallback((_) =>
                                _showSnackBar(context,
                                    "Impossible d'obtenir les pharmacies", false));
                          } else {
                            SchedulerBinding.instance.addPostFrameCallback((_) =>
                                _showSnackBar(
                                    context,
                                    "Liste des pharmacies affichée avec succès",
                                    true));
                          }
                        }
                      } else if (snapshot.hasError) {
                        return Container(
                          child: new FutureBuilder<List<Pharma>>(
                            future: widget.storage.readPharmas(),
                            builder: (context, snapshot2) {
                              pharmas = snapshot2.data;
                              if (pharmas == null) {
                                SchedulerBinding.instance.addPostFrameCallback((_) =>
                                    _showSnackBar(context,
                                        "Impossible d'obtenir les pharmacies", false));
                                return new Text("");
                              } else {
                                SchedulerBinding.instance.addPostFrameCallback((_) =>
                                    _showSnackBar(
                                        context,
                                        "Liste des pharmacies affichée avec succès",
                                        true));
                                return pharmaListWidget();
                              }
                            },
                          ),
                        );
                        print('${snapshot.error}');
                      }
                      return pharmaListWidget();
                      return Center(
                        child: CircularProgressIndicator(strokeWidth: 5),
                      );
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

  void _showSnackBar(BuildContext context, String msg, bool ok) {
    if (!notifDisplay) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(msg),
        duration: const Duration(seconds: 5),
      ));
      if (ok) {
        notifDisplay   = true;
      }
    }
  }

  Widget pharmaListWidget() {
    // Melange les pharmas
    // pharmas.shuffle();

    filterPharmas = pharmas;

    if (_searchText.isNotEmpty) {
      List<Pharma> tempListPharma = new List<Pharma>();
      filterPharmas.forEach((Pharma p) {
        if (p.name.toLowerCase().contains(_searchText.toLowerCase())) {
          tempListPharma.add(p);
          print(tempListPharma.toString());
        }
      });
      filterPharmas = tempListPharma;
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: pharmas == null ? 0 : filterPharmas.length,
        itemBuilder: (context, position) {
          return new PharmaCardWidget(
            titre: filterPharmas[position].name,
            icon: Icons.search,
            superDescription: filterPharmas[position].trainingNeed,
            description: filterPharmas[position].address.toString(),
            dialog: PharmaCardDialog(
                titre: filterPharmas[position].name,
                location: filterPharmas[position].location),
          );
        });
  }
}
