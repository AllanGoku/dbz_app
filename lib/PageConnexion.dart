import 'dart:convert';
import 'dart:io';

import 'package:dbz_app/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageConnexion extends StatelessWidget {
  PageConnexion({super.key});

  TextEditingController _mail = TextEditingController();
  TextEditingController _password = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserProvider? provider;
  User? userRecup;

  Future<void> _connexion(context) async {
    if (_mail.text == "" && _password.text == "") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text('Veuillez remplir tous les champs !'),
            );
          });
    } else {
      final SharedPreferences prefs = await _prefs;
      provider = await UserProvider.instance;
      User user = User(_mail.text, _password.text);
      Future<User?> recherche = provider!.rechercheUserParMail(_mail.text);
      recherche.then((users) {
        String? mail;
        String? password;
        if (users != null) {
          mail = users!.mail;
          password = users!.password;
        }
        if (mail == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Erreur'),
                  content: Text('Adresse mail ou mot de passe incorrect !'),
                );
              });
        } else {
          if (mail == _mail.text && _password.text == password) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Connexion réussie'),
                    content: Text('Vous êtes connecté !'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          prefs.setString("mailConnexion", mail!);
                          Navigator.pushNamed(context, '/accueil');
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                });

          }
          else{
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Erreur'),
                    content: Text('Adresse mail ou mot de passe incorrect 2 !'),
                  );
                });
          }
        }
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Page de connexion"), automaticallyImplyLeading: false),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: _mail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Adresse mail',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.5),
              ),
              TextFormField(
                obscureText: true,
                maxLines: 1,
                minLines: 1,
                controller: _password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
              ElevatedButton(
                  onPressed: () {
                    _connexion(context);
                  },
                  child: Text("Se connecter")),
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inscription');
                  },
                  child: Text("S'inscrire")),
            ],
          ),
        ));
  }
}
