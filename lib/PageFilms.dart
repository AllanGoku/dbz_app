import 'package:dbz_app/monAppBar.dart';
import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool showText = false;

class PageFilms extends StatefulWidget {
  PageFilms({super.key});

  // This widget is the root of your application.
  @override
  _PageFilmsState createState() => _PageFilmsState();
}

class _PageFilmsState extends State<PageFilms> {
  Map<int, dynamic>? _films;

  Future<Map<int, dynamic>> obtenirFilms() async {
    final response = await http.get(
        Uri.parse(
            'https://anime-db.p.rapidapi.com/anime?page=1&size=15&search=Dragon%20ball%20z&sortBy=title&sortOrder=asc&types=Movie'),
        headers: {
          'X-Rapidapi-Key':
              'a4927f5b41msh452a6972b3b2e8ap136099jsn3cdae7586830',
          'X-Rapidapi-Host': 'anime-db.p.rapidapi.com'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final films = <int, dynamic>{};

      for (int i = 0; i < data['data'].length; i++) {
        final film = data['data'][i];
        films[i] = film;
      }
      print(films);
      return films;
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }

  void initState() {
    super.initState();
    obtenirFilms().then((data) {
      setState(() {
        _films = data;
      });
    });
  }

  List<bool> _isExpandedList = List.generate(15, (index) => false);

  void _toggleExpanded(int index) {
    setState(() {
      _isExpandedList[index] = !_isExpandedList[index];

      for (int i = 0; i < _isExpandedList.length; i++) {
        if (i != index) {
          _isExpandedList[i] = false;
        }
      }
    });
  }

  String recupTitreAlternatif(int index) {
    String titreAlternatif = '';
    if (_films![index]!['alternativeTitles'] != null) {
      List<dynamic> listTitresAlternatifes =
          (_films![index]!['alternativeTitles']) as List<dynamic>;
      int indice = listTitresAlternatifes.length - 1;
      titreAlternatif = _films![index]!['alternativeTitles'][indice];
    }
    return titreAlternatif;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MonAppBar(titre: "Films"),
        drawer: MonDrawer(),
        body: _films == null
            ? Center(
            child: Column(
              children: [
                Text('Chargement des films ...'),
                CircularProgressIndicator(),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ))
            : ListView.builder(
                itemCount: _films?.length,
                padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                          onTap: () {
                            _toggleExpanded(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  // couleur de l'ombre
                                  spreadRadius: 5,
                                  // rayon d'expansion de l'ombre
                                  blurRadius: 0,
                                  // rayon de flou de l'ombre
                                  offset: Offset(0, 3), // décalage de l'ombre
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _toggleExpanded(index);
                                  },
                                  child: Container(
                                    height: 80,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          _films![index]!['image'],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        Expanded(
                                            child: Text(
                                          recupTitreAlternatif(index),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                          maxLines: 3,
                                        )),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        Icon(
                                          _isExpandedList[index]
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_isExpandedList[index])
                                  Container(
                                    child: Column(children: [
                                      Text(
                                        'Description : ', //${_items[index]}
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        '${_films![index]!['synopsis']}',
                                      ),
                                    ]),
                                  ),
                              ],
                            ),
                          )));
                },
              ) /**/);
  }
}
