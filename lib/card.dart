import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _CalculCardWidgetState extends State<CalculCardWidget> {
  double pAchatBrut = 0;
  double tauxRemise = 0;
  double _resCalcul = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(12.0),
            child: Row(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[Icon(Icons.attach_money), Text(widget.titre)],
            ),
            onPressed: () {
              _showDialog(context);
            },
          ),
          ListTile(
            title: Text(widget.superDescription),
            subtitle: Text(
              widget.description,
              style: TextStyle(
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    void _setResCalcul() {
      setState(() {
        _resCalcul = pAchatBrut * (1 - tauxRemise);
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          title: new Text(widget.dialog.titre),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: widget.dialog.labelGauche,
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
                          labelText: widget.dialog.labelDroite,
                          labelStyle: TextStyle(
                            fontSize: 12,
                          )),
                      keyboardType: TextInputType.number,
                      onChanged: (newVal) {
                        tauxRemise = double.parse(newVal) / 100;
                        _setResCalcul();
                      },
                    ),
                  ),
                ],
              ),
            ),
            new SimpleDialogOption(
              child: new Text(widget.dialog.labelResultat + " " + ": $_resCalcul€"),
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

class CalculCardWidget extends StatefulWidget {
  const CalculCardWidget(
      {Key key,
      this.titre,
      this.superDescription,
      this.description,
      this.dialog})
      : super(key: key);

  final String titre;

  final String superDescription;

  final String description;

  final CardDialog dialog;

  @override
  _CalculCardWidgetState createState() => _CalculCardWidgetState();
}

class CardDialog {
  final String titre;
  final String labelGauche;
  final String labelDroite;
  final String labelResultat;

  const CardDialog({this.titre, this.labelGauche, this.labelDroite,
      this.labelResultat});
}
