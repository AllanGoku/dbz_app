import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool showText = false;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class PagePersonnages extends StatefulWidget {
  PagePersonnages({super.key});

  // This widget is the root of your application.
  @override
  _PagePersonnagesState createState() => _PagePersonnagesState();
}

class _PagePersonnagesState extends State<PagePersonnages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page d'accueil"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
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
                              _prefs.then((prefs) => {
                                    prefs.remove('mailConnexion'),
                                    prefs.remove('pseudoConnexion')
                                  });
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: Text('Oui'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        drawer: MonDrawer(),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          shrinkWrap: true,
          children: <Widget>[
            Card(
              child: Expanded(
                  child: Column(children: <Widget>[
                Image.asset('images/goku.png'),
                Text('Goku'),
                if (showText)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "TROP BIEN C'EST GOKU",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (showText == true)
                        showText = false;
                      else
                        showText = true;
                    });
                    print(showText);
                  },
                  child: Text(showText ? "Masquer" : "En savoir plus"),
                ),
              ])),
            )
          ],
        ));
  }
}
