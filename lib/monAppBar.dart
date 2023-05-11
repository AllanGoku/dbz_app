import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonAppBar extends StatelessWidget implements PreferredSizeWidget{

  const MonAppBar({required this.titre});

  final String titre;




  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return AppBar(
      title: Text(titre),
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

