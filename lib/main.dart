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
                labelResultat: "fez",
                resultat: (a, b) {
                  return a * (1 - b);
                },
              ),
            ),
            CalculCardWidget(
              titre : "Prix d'achat net",
              superDescription: "Calcul du prix d'achat net",
              description: "En fonction du prix d'achat brute et d'un taux de remise",
              dialog: CardDialog(
                titre: "Calcul prix d'achat net",
                labelGauche: "Prix d'achat brut (€)",
                labelDroite: "Taux de remise (%)",
                labelResultat: "Prix d'achat net",
                resultat: (a, b) {
                  return a * (1 - b);
                },
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
