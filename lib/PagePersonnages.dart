import 'package:dbz_app/monAppBar.dart';
import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Future<Map<String, dynamic>?> obtenirInformationsPersonnage(
      String personnage) async {
    if (personnage == "Vegeta" || personnage == "Goku") {
      final response = await http.get(Uri.parse(
          'https://superheroapi.com/api/1549323725556590/search/$personnage'));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)["response"] == "error") {
          print('Personnage non trouvé');
          throw Exception('Personnage non trouvé');
        } else {
          return jsonDecode(response.body);
        }
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } else{
      if (personnage == "Gohan"){
        final jsonString = await rootBundle.loadString('assets/personnagesDragonBall.json');
        return jsonDecode(jsonString)["data"][0];
      }
      if (personnage == "Piccolo"){
        final jsonString = await rootBundle.loadString('assets/personnagesDragonBall.json');
        return jsonDecode(jsonString)["data"][1];
      }
    }
  }

  void initState() {
    super.initState();
    for (int i = 0; i < listPersonnages.length; i++) {
      obtenirInformationsPersonnage(listPersonnages[i]).then((data) {
        setState(() {
          _personnages.add(data);
        });
      });
    }
  }

  List<String> listPersonnages = ["Goku", "Vegeta","Gohan","Piccolo"];

  List<dynamic> _personnages = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final cardHeight = height * 0.4;
    return Scaffold(
        appBar: MonAppBar(titre: "Personnages"),
        drawer: MonDrawer(),
        body: _personnages == null &&
                _personnages.length < listPersonnages.length
            ? Center(
                child: Column(
                children: [
                  Text('Chargement des personnages...'),
                  CircularProgressIndicator(),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
                itemCount: _personnages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.network(
                            _personnages[index]['results'][0]['image']['url'],
                            height: cardHeight * 0.7),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _personnages[index]['results'][0]['name'],
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(children: [
                              Text(
                                "Nom complet : ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                _personnages[index]['results'][0]['biography']
                                    ['full-name'],
                              ),
                            ])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Alias : ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                _personnages[index]['results'][0]['biography']
                                    ['aliases'][0],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Race : ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Text(
                                _personnages[index]['results'][0]['appearance']
                                ['race'],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }));
  }
}
