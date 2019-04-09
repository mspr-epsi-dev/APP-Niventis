import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niventis Application',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Alpha Niventis'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showDialog(BuildContext context) {
    double pAchatBrut = 0;
    double tauxRemise = 0;
    double _resCalcul = 0;

    void _setResCalcul() {
      setState(() {
        _resCalcul = pAchatBrut*(1-tauxRemise);
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          title: new Text("Calcul prix d'achat net"),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Prix d\'achat brut (€)',
                          labelStyle: TextStyle(
                            fontSize: 12,
                          )),
                      keyboardType: TextInputType.number,
                      onChanged: (newVal) {
                        pAchatBrut = double.parse(newVal);
                        _setResCalcul();
                      },
                    ),
                  ),
                  new Expanded(
                    child: new TextField(
                      decoration: new InputDecoration(
                          labelText: 'Taux de remise (%)',
                          labelStyle: TextStyle(
                            fontSize: 12,
                          )),
                      keyboardType: TextInputType.number,
                      onChanged: (newVal) {
                        tauxRemise = double.parse(newVal)/100;
                        _setResCalcul();
                      },
                    ),
                  ),
                ],
              ),
            ),
            new SimpleDialogOption(
              child: new Text("Prix d\'achat net : $_resCalcul€"),
            ),
            new SimpleDialogOption(
              child: new FlatButton(
                child: new Text("Fermer"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Bienvenue sur la calculatrice de Niventis',
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.attach_money),
                        Text("Prix d\'achat net")
                      ],
                    ),
                    onPressed: () {
                      _showDialog(context);
                    },
                  ),
                  const ListTile(
                    title: Text('Calcul du prix d\'achat net'),
                    subtitle: Text(
                      'En fonction du prix d\'achat brute et d\'un taux de remise',
                      style: TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
