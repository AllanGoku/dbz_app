import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonDrawer extends StatelessWidget {
  const MonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange[600],
              image: DecorationImage(
                image: AssetImage('images/background_dragon_ball.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
            child: null,
          ),
          ListTile(
            leading: Image.asset('images/icon_accueil.png'),
            title: Text(
              'Accueil',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/accueil');
              // Mettre ici le code à exécuter quand l'utilisateur clique sur l'option "Accueil"
            },
          ),
          ListTile(
            leading: Image.asset("images/icon_personnages.png &&&"),
            title: Text(
              'Personnages',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/personnages');
              // Mettre ici le code à exécuter quand l'utilisateur clique sur l'option "Personnages"
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Mettre ici le code à exécuter quand l'utilisateur clique sur l'option "Settings"
            },
          ),
        ],
      ),
    );
  }
}
