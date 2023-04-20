import 'package:flutter/material.dart';

class PageCommentaires extends StatelessWidget {
  PageCommentaires({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page de connexion"),
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
                child: Text("Page Accueil"),
                color: Colors.red,
              ),
            ],
          ),
        ));
  }
}