import 'package:dbz_app/User.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';

class PageInscription extends StatelessWidget {
  PageInscription({super.key});

  TextEditingController _mail = TextEditingController();
  TextEditingController _password = TextEditingController();
  UserProvider? provider;

  void _inscription(context) async {
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
      provider = await UserProvider.instance;
      User user = User(_mail.text, _password.text);
      Future<User?> recherche = provider!.rechercheUserParMail(_mail.text);
      recherche.then((users) {
        String? mail;
        if (users != null) {
          mail = users?.mail;
        }
        if (mail != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Inscription échouée'),
                content: Text('Cette adresse mail est déjà utilisée.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          Future<int> ajout = provider!.insert(user);
          if (ajout == -1) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Inscription échouée'),
                  content:
                      Text('Une erreur est survenue lors de l\'inscription.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            // Afficher une boîte de dialogue pour indiquer que l'inscription a réussi
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Inscription réussie'),
                  content: Text('Vous êtes maintenant inscrit.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/");
                        provider!.getAllUsers().then((users) {
                          users.forEach((user) {
                            print(user.mail);
                            print(user.password);
                          });
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
        // Utiliser la valeur de "mail" pour votre condition
      });
      //recherche.then((value) => print(value?.mail));
    }
  }

  Future<UserProvider> getInstance() async =>
      provider = await UserProvider.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page d'inscription"),
        ),
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
                    _inscription(context);
                  },
                  child: Text("Valider")),
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
            ],
          ),
        ));
  }
}
