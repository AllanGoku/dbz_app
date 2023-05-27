import 'package:dbz_app/monAppBar.dart';
import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAccueil extends StatelessWidget {
  PageAccueil({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MonAppBar(titre: "Accueil"),
      drawer: MonDrawer(),
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
            ),
            Image.asset('assets/images/goku2.png')
          ]
        ),
      ),
    );
  }
}