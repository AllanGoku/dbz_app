import 'package:dbz_app/monAppBar.dart';
import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool showText = false;


class PagePersonnages extends StatefulWidget {
  PagePersonnages({super.key});

  // This widget is the root of your application.
  @override
  _PagePersonnagesState createState() => _PagePersonnagesState();
}

class _PagePersonnagesState extends State<PagePersonnages> {

  Future<Map<String,dynamic>?> obtenirInformationsPersonnage(String personnage) async {
    final response = await http.get(Uri.parse(
        'https://superheroapi.com/api/1549323725556590/search/$personnage'));
    if (response.statusCode == 200) {
      if (response.body ==
          '{"response":"error","error":"character with given name not found"}') {
        print('Personnage non trouvé');
        throw Exception('Personnage non trouvé');
      } else {
        print(
            jsonDecode(response.body)['results'][0]['biography']['full-name']);
        return jsonDecode(response.body);
      }
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }

  Future<String?> obtenirImagePersonnage(String personnage) async {
    var info =  (await obtenirInformationsPersonnage(personnage));
    var id = info!['results'][0]['id'];
    final response = await http.get(Uri.parse(
        'https://superheroapi.com/api/1549323725556590/$id/image'));
    if (response.statusCode == 200) {
      if (response.body ==
          '{ "response": "error","error": "invalid id" }') {
        print('Personnage non trouvé');
        throw Exception('Personnage non trouvé');
      } else {
        print(
            jsonDecode(response.body)["url"]);
        return jsonDecode(response.body)["url"];
      }
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final cardHeight = height * 0.4;
    return Scaffold(
        appBar: MonAppBar(titre: "Personnages"),
        drawer: MonDrawer(),
        body: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 15,
          shrinkWrap: true,
          children: <Widget>[
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FutureBuilder<String?>(
                    future: obtenirImagePersonnage("goku"),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.hasData) {
                        return Image.network('${snapshot.data}',
                            height: cardHeight * 0.7);
                      } else if (snapshot.hasError) {
                        return Text(
                            'Une erreur est survenue : ${snapshot.error}');
                      } else {
                        return Text('Chargement en cours...');
                      }
                    },
                  ),
                  //Image.asset('images/goku2.png', height: cardHeight * 0.7),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Goku',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FutureBuilder<Map<String,dynamic>?>(
                      future: obtenirInformationsPersonnage("goku"),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String,dynamic>?> snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data!['results'][0]['biography']['full-name']}');
                        } else if (snapshot.hasError) {
                          return Text(
                              'Une erreur est survenue : ${snapshot.error}');
                        } else {
                          return Text('Chargement en cours...');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
