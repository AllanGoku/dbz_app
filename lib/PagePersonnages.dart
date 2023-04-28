import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagePersonnages extends StatelessWidget {
  PagePersonnages({super.key});
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page des personnages"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Page des personnages',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
