import 'package:dbz_app/User.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PageInscription extends StatefulWidget {
  PageInscription({super.key});

  @override
  _PageInscriptionState createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  TextEditingController _mail = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _pseudo = TextEditingController();
  UserProvider? provider;
  bool boutonConnexion = false;

  void _activerBouton() {
    setState(() {
      if (_mail.text == "" || _password.text == "" || _pseudo.text == "") {
        boutonConnexion = false;
      } else {
        if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_mail.text) ==
            false) {
          boutonConnexion = false;
        } else {
          boutonConnexion = true;
        }
      }
    });
  }

  void _inscription(context) async {
    if (_mail.text == "" && _password.text == "" && _pseudo.text == "") {
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
      User user = User(_mail.text, _password.text, _pseudo.text);
      Future<User?> recherche = provider!.rechercheUserParMail(_mail.text);
      recherche.then((users) {
        String? mail;
        if (users != null) {
          mail = users.mail;
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
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      });
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
                onEditingComplete: () {
                  _activerBouton();
                },
                onChanged: (value) {
                  setState(() {
                    _activerBouton();
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Entrez une adresse email valide';
                  } else {
                    return null;
                  }
                },
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
                onChanged: (value) {
                  setState(() {
                    _activerBouton();
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: _pseudo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pseudo',
                ),
                onChanged: (value) {
                  setState(() {
                    _activerBouton();
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre pseudo';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (boutonConnexion) {
                      _inscription(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        boutonConnexion == false ? Colors.grey : Colors.green,
                  ),
                  child: Text("Valider")),
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
            ],
          ),
        ));
  }
}
