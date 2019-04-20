import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niventis Application',
      theme: ThemeData(
        primaryColor: Colors.greenAccent,
      ),
      home: MyHomePage(title: 'Alpha Niventis'),
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
            Text('Bienvenue sur la calculatrice de Niventis'),
            CalculCardWidget(
              titre : "Taux de remise",
              superDescription: "",
              description: "",
              dialog: CardDialog(
                titre: "test",
                labelGauche: "test",
                labelDroite: "test",
                labelResultat: "fez"
              ),
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
}
