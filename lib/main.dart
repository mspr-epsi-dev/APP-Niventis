import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';

import 'pharma.dart';
import 'card.dart';
import 'package:niventis_app/pharmas_storage.dart';

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
  List<Pharma> pharmas;
  List<Pharma> filterPharmas;
  String _position = "Aucune position";
  double _positionLong;
  double _positionLatt;
  bool pharmasPersist = false;
  bool notif_display = false;

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

  void getLocation() async {
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((location) {
      if (location != null) {
        setState(() {
          _positionLong = location.longitude;
          _positionLatt = location.latitude;
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
                  child: new FutureBuilder<List<Pharma>>(
                    future: Pharma.getPharmas(_positionLong, _positionLatt),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        pharmas = snapshot.data;
                        if (!pharmasPersist) {
                          print("Pharma persist");
                          print(widget.storage.writePharmas(pharmas));
                          pharmasPersist = true;
                        }
                      } else if (snapshot.hasError) {
                        widget.storage.readPharmas().then((String value) {
                          final lp =
                              jsonDecode(value).cast<Map<String, dynamic>>();
                          pharmas = lp
                              .map<Pharma>((json) => new Pharma.fromJson(json))
                              .toList();
                        });
                        print(pharmas.toString());
                        print('${snapshot.error}');
                      }
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
                        return pharmaListWidget();
                      }

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
    if (!notif_display) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(msg),
        duration: const Duration(seconds: 5),
      ));
      if (ok) {
        notif_display = true;
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
