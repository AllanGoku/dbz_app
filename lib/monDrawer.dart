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
                image: AssetImage('assets/images/background_dragon_ball.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
            child: null,
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            leading: SizedBox(
                width: 60, child: Image.asset('assets/images/icon_accueil.png')),
            title: Text(
              ' Accueil',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/accueil');
              // Mettre ici le code à exécuter quand l'utilisateur clique sur l'option "Accueil"
            },
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          ListTile(
            leading: SizedBox(
                width: 65, child: Image.asset("assets/images/icon_personnages.png")),
            title: Text(
              'Personnages',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/personnages');
              // Mettre ici le code à exécuter quand l'utilisateur clique sur l'option "Personnages"
            },
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            leading: SizedBox(
                width: 65, child: Image.asset("assets/images/icon_films.png")),
            title: Text(
              'Films',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/films');
              // Mettre ici le code à exécuter quand l'utilisateur clique sur l'option "films"
            },
          ),
        ],
      ),
    );
  }
}
