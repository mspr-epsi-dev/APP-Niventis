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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScaffoldState scaffold;
  String _searchText = "";
  List<Pharma> _pharmas;
  List<Pharma> _filterPharmas;
  String _position = "Aucune position";

  void _searchPharmas() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
        _filterPharmas = _pharmas;
      });
    } else if (_pharmas != null) {
      setState(() {
        _searchText = _filter.text;
      });
    }
  }

  void getLocation() async {
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((location) {
      if (location != null) {
        _position = location.toString();
        Pharma.latt = location.latitude;
        Pharma.long = location.longitude;
        Pharma.getPharmas().then((List<Pharma> pharmasResult) {
          setState(() {
            _pharmas = pharmasResult;
          });
        }).catchError((error) {
          print(error.toString());
          widget.storage.readPharmas().then((List<Pharma> pharmas) {
            setState(() {
              _pharmas = pharmas;
            });
          });
        });
      }
    }).whenComplete(() {
      print("Fin localisation");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            controller: _filter,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '$_position',
                            )),
                      ),
                      new IconButton(
                          icon: Icon(Icons.search), onPressed: _searchPharmas),
                    ],
                  )),
              new Container(
                margin: const EdgeInsets.only(top: 5),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 474),
                  child: new Builder(
                    builder: (BuildContext context) {
                      if (_pharmas != null) {
                        widget.storage.writePharmas(_pharmas).whenComplete(() {
                          print("Pharmacies saved");
                          SchedulerBinding.instance.addPostFrameCallback((_) =>
                              _showInSnackBar(
                                  "Pharmacies affichées avec succès"));
                        });
                      } else {
                        SchedulerBinding.instance.addPostFrameCallback(
                            (_) => _showInSnackBar("Aucune pharmacie"));
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

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget pharmaListWidget() {
    _filterPharmas = _pharmas;

    if (_searchText.isNotEmpty) {
      List<Pharma> tempListPharma = new List<Pharma>();
      _filterPharmas.forEach((Pharma p) {
        if (p.name.toLowerCase().contains(_searchText.toLowerCase())) {
          tempListPharma.add(p);
          print(tempListPharma.toString());
        }
      });
      _filterPharmas = tempListPharma;
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _pharmas == null ? 0 : _filterPharmas.length,
        itemBuilder: (context, position) {
          return new PharmaCardWidget(
            titre: _filterPharmas[position].name,
            icon: Icons.search,
            description: _filterPharmas[position].address,
            superDescription: (_filterPharmas[position].details == null)
                ? ""
                : _filterPharmas[position].details.trainingNeed,
            dialog: PharmaCardDialog(
                titre: _filterPharmas[position].name,
                distance: _filterPharmas[position].distance),
          );
        });
  }
}
