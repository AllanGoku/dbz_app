import 'package:dbz_app/monAppBar.dart';
import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAccueil extends StatelessWidget {
  PageAccueil({super.key});
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
            Image.asset('images/goku2.png')
            /*
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset(
                'images/goku.png',
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
             */
          ]
        ),
      ),
    );
  }
}