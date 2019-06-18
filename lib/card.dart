import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _PharmaCardWidgetState extends State<PharmaCardWidget> {
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
              children: <Widget>[Icon(widget.icon), Text(widget.titre)],
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
        //_resCalcul = widget.dialog.resultat(chiffreA, chiffreB);
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          title: new Text(widget.dialog.titre),
          children: <Widget>[
            new SimpleDialogOption(child: new Text("Localisation : " + widget.dialog.location.toString())),
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

class PharmaCardWidget extends StatefulWidget {
  const PharmaCardWidget(
      {Key key,
      this.titre,
      this.icon = Icons.euro_symbol,
      this.superDescription,
      this.description,
      this.dialog})
      : super(key: key);

  final String titre;

  final IconData icon;

  final String superDescription;

  final String description;

  final PharmaCardDialog dialog;

  @override
  _PharmaCardWidgetState createState() => _PharmaCardWidgetState();
}

class PharmaCardDialog {
  final String titre;
  final location;

  const PharmaCardDialog({this.titre, this.location});
}
