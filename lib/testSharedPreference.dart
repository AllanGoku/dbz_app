import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class Personne {
  String _nom;
  String _prenom;
  String _age;

  Personne(this._nom, this._prenom, this._age);

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  String get prenom => _prenom;

  set prenom(String value) {
    _prenom = value;
  }

  String get nom => _nom;

  set nom(String value) {
    _nom = value;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Shared Preferences'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Personne personneEnregistree = Personne("DOE", "John", "35");
  Personne? personneRecuperee;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> enregistrer() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("personne", [
      '${personneEnregistree.nom}',
      '${personneEnregistree.prenom}',
      '${personneEnregistree.age}'
    ]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enregistrement'),
            content: Text('Les données ont été enregistrées !'),
          );
        });
  }

  Future<void> recuperer() async {
    final SharedPreferences prefs = await _prefs;

    if (prefs.getStringList("personne") != null) {
      var liste = prefs.getStringList("personne");
      if (liste!.isNotEmpty) {
        setState(() {
          personneRecuperee = Personne(liste[0], liste[1], liste[2]);
        });
      }
    }
  }

  Future<void> supprimer() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("personne");
    setState(() {
      personneRecuperee = null;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Suppression'),
            content: Text('Les données ont été supprimées !'),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 80.0,
              color: Colors.blue,
            ),
            Text('Données soumises :'),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Nom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('${personneEnregistree.nom}',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Prénom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('${personneEnregistree.prenom}',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Age : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('${personneEnregistree.age}',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Text('Données récupérées :'),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Nom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee != null
                          ? Text('${personneRecuperee!.nom}',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                          : Text(
                        'Aucune donnée',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Prénom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee != null
                          ? Text('${personneRecuperee!.prenom}',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                          : Text(
                        'Aucune donnée',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Age : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee != null
                          ? Text('${personneRecuperee!.age}',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                          : Text(
                        'Aucune donnée',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                    onPressed: enregistrer,
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text('Enregistrer')),
                MaterialButton(
                    onPressed: recuperer,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('Lire les données')),
                MaterialButton(
                    onPressed: supprimer,
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
