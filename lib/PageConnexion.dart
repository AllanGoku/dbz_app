import 'package:dbz_app/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageConnexion extends StatefulWidget {
  PageConnexion({super.key});


  @override
  _PageConnexionState createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  TextEditingController _mail = TextEditingController();
  TextEditingController _password = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserProvider? provider;
  User? userRecup;
  bool boutonConnexion = false;
  bool resterConnecte = false;

  void initState() {
    super.initState();
    dejaConnecte();
  }

  // Fonction vérifiant si l'utilisateur est déjà connecté (si lors de la connexion précédente, il a coché la case "rester connecté")
  Future<void> dejaConnecte() async {
    final SharedPreferences prefs = await _prefs;
    String? mail = prefs.getString("mailConnexion");
    String? pseudo = prefs.getString("pseudoConnexion");
    bool? connectionActive = prefs.getBool("connectionActive");
    if(mail != null && pseudo != null && connectionActive == true){
      Navigator.pushNamed(context, '/accueil');
    }
  }

  // Fonction permettant de vérifier si les champs sont remplis et si le mail est valide, si oui, le bouton de connexion est activé
  void _activerBouton() {
    setState(() {
      if (_mail.text == "" || _password.text == "") {
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

  // Fonction qui vérifie que tout les champs sont valides et qui vérifie que l'adresse mail existe et que le mot de passe associé correspond à celui entré
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
      Future<User?> recherche = provider!.rechercheUserParMail(_mail.text);
      recherche.then((users) {
        String? mail;
        String? password;
        String? pseudo;
        if (users != null) {
          mail = users.mail;
          password = users.password;
          pseudo = users.pseudo;
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
                          prefs.setString("pseudoConnexion", pseudo!);
                          if (resterConnecte == true) {
                            prefs.setBool("connectionActive", true);
                          } else {
                            prefs.setBool("connectionActive", false);
                          }
                          Navigator.pushNamed(context, '/accueil');
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Erreur'),
                    content: Text('Adresse mail ou mot de passe incorrect !'),
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
              Row(
                children: [
                  Checkbox(
                      activeColor: Colors.deepOrange,
                      value: resterConnecte,
                      onChanged: (value) {
                        setState(() {
                          resterConnecte = !resterConnecte;
                        });
                      }
                  ),
                  Text("Rester connecté"),
                ],
              )

              ,
              Padding(
                padding: const EdgeInsets.all(3.5),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (boutonConnexion) {
                      _connexion(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boutonConnexion == false ? Colors.grey : Colors.deepOrange,
                  ),
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
