import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'pharma.dart';
import 'card.dart';

void main() => runApp(MyApp());

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

/** class PharmasStorage {
    Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
    }

    Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/pharmas.json');
    }

    Future<int> readPharmas() async {
    try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return int.parse(contents);
    } catch (e) {
    // If encountering an error, return 0
    return 0;
    }
    }

    Future<File> writePharmas(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
    }
    } **/

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Pharma> pharmas;
  List<Pharma> filterPharmas;
  String _position = "Aucune position";
  double _positionLong;
  double _positionLatt;

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
                        pharmas.shuffle();
                        filterPharmas = pharmas;

                        if (!(_searchText.isEmpty)) {
                          List<Pharma> tempListPharma = new List<Pharma>();
                          filterPharmas.forEach((Pharma p) {
                            if (p.name
                                .toLowerCase()
                                .contains(_searchText.toLowerCase())) {
                              tempListPharma.add(p);
                            } else {
                              tempListPharma.remove(p);
                            }
                          });
                          filterPharmas = tempListPharma;
                        }
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount:
                                pharmas == null ? 0 : filterPharmas.length,
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
                                    location: pharmas[position].location),
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
