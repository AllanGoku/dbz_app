import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAccueil extends StatelessWidget {
  PageAccueil({super.key});
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // This widget is the root of your application.

  Future<String?> recupMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("mailConnexion");
  }
  Future<String> printMailConnexion() async {
    String? mailConnexion = await recupMail();
    print(mailConnexion);
    return mailConnexion.toString();
  }
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page d'accueil"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Déconnexion'),
                  content: Text('Voulez-vous vous déconnecter ?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Non'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _prefs.then((prefs) => {prefs.remove('mailConnexion'),
                          prefs.remove('pseudoConnexion')});
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Oui'),
                    ),
                  ],
                );
              });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then((prefs) => prefs.getString('pseudoConnexion')),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.hasData) {
                  return Text('Salut Super guerrier ${snapshot.data}');
                } else if (snapshot.hasError) {
                  return Text('Une erreur est survenue : ${snapshot.error}');
                } else {
                  return Text('Chargement en cours...');
                }
              },
            )
          ]
        ),
      )
    );
  }*/






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.asset("goku.png"),
            Positioned(
              top: 80,
              left: 30,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Bonjour, bienvenue sur mon application Dragon Ball Z !',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}