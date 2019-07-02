import 'dart:convert';

import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

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
        title: 'Alpha Niventis V3',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyData {
  String reponse_question1 = '';
  String reponse_question2 = '';
  String reponse_question3 = '';
}

class _MyHomePageState extends State<MyHomePage> {
  ScaffoldState scaffold;
  bool notifDisplay = false;
  static var _focusNode = new FocusNode();
  List <Formu> _formus;
  int currStep = 0;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static MyData data = new MyData();

  List<Step> _steps = [
    new Step(
        title: new Text('Quel sont vos meilleurs ventes?'),
        //subtitle: const Text('Enter le nom du produit'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: new TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          autocorrect: false,
          onSaved: (String value) {
            data.reponse_question1 = value;
          },
          maxLines: 1,
          //initialValue: 'Aseem Wangoo',
          validator: (value) {
            if (value.isEmpty || value.length < 1) {
              return 'Please enter name';
            }
          },
          decoration: new InputDecoration(
              labelText: '',
              hintText: 'Nom de produit demander',
              //filled: true,
              icon: const Icon(Icons.person),
              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Quel produit faite-vous vos le plus de marge ?'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: new TextFormField(
          keyboardType: TextInputType.phone,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || value.length < 1) {
              return 'Please enter name';
            }
          },
          onSaved: (String value) {
            data.reponse_question2 = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: '',
              hintText: 'Nom de produit demander',
              icon: const Icon(Icons.person),
              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Quelle est votre chiffre d`affaires ?'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content: new TextFormField(
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || value.length < 10000000) {
              return 'Please enter valid number';
            }
          },
          onSaved: (String value) {
            data.reponse_question3 = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: '',
              hintText: 'Nom de produit demander',
              icon: const Icon(Icons.person),
              labelStyle:
              new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    // new Step(
    //     title: const Text('Fifth Step'),
    //     subtitle: const Text('Subtitle'),
    //     isActive: true,
    //     state: StepState.complete,
    //     content: const Text('Enjoy Step Fifth'))
  ];


  void _submitDetails() {
    final FormState formState = _formKey.currentState;

    if (!formState.validate()) {
      //showSnackBarMessage('Please enter correct data');
    } else {
      formState.save();
      print("reponse_question1: ${data.reponse_question1}");
      print("reponse_question2: ${data.reponse_question2}");
      print("reponse_question3: ${data.reponse_question3}");

      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Details"),
            //content: new Text("Hello World"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text("reponse_question1 : " + data.reponse_question1),
                  new Text("reponse_question2 : " + data.reponse_question2),
                  new Text("reponse_question3 : " + data.reponse_question3),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }
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
              margin: const EdgeInsets.only(top: 5),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(height: 474),
                child: new FutureBuilder<List<Formu>>(
                  future: Formu.getFormus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print('888888888888888');
                      _formus = snapshot.data;
                      return new Container(
                          child: new Form(
                            key: _formKey,
                            child: new ListView(children: <Widget>[
                              new Stepper(
                                steps: _steps,
                                type: StepperType.vertical,
                                currentStep: this.currStep,
                                onStepContinue: () {
                                  setState(() {
                                    if (currStep < _steps.length - 1) {
                                      currStep = currStep + 1;
                                    } else {
                                      currStep = 0;
                                    }
                                    // else {
                                    // Scaffold
                                    //     .of(context)
                                    //     .showSnackBar(new SnackBar(content: new Text('$currStep')));

                                    // if (currStep == 1) {
                                    //   print('First Step');
                                    //   print('object' + FocusScope.of(context).toStringDeep());
                                    // }

                                    // }
                                  });
                                },
                                onStepCancel: () {
                                  setState(() {
                                    if (currStep > 0) {
                                      currStep = currStep - 1;
                                    } else {
                                      currStep = 0;
                                    }
                                  });
                                },
                                onStepTapped: (step) {
                                  setState(() {
                                    currStep = step;
                                  });
                                },
                              ),
                              new RaisedButton(
                                child: new Text(
                                  'Valider le formulaire ',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: _submitDetails,
                                color: Colors.blue,
                              ),
                            ]),
                          ));
                    } else if (snapshot.hasError) {
                      print('dodo ddddddddddddddddddddddd');
                      print('${snapshot.error}');
                    }
                    return Center(
                      child: CircularProgressIndicator(strokeWidth: 5)
                      ,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg, bool ok) {
    if (!notifDisplay) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(msg),
        duration: const Duration(seconds: 5),
      ));
      if (ok) {
        notifDisplay = true;
      }
    }
  }
}
