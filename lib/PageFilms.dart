import 'package:dbz_app/monDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool showText = false;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class PageFilms extends StatefulWidget {
  PageFilms({super.key});

  // This widget is the root of your application.
  @override
  _PageFilmsState createState() => _PageFilmsState();
}

class _PageFilmsState extends State<PageFilms> {

  Map<String,dynamic>? _films;

  Future<Map<String, String>?> obtenirFilms() async {
    final response = await http.get(Uri.parse('https://anime-db.p.rapidapi.com/anime?page=1&size=15&search=Dragon%20ball%20z&sortBy=title&sortOrder=asc&types=Movie'),
        headers: {
          'X-Rapidapi-Key': 'a4927f5b41msh452a6972b3b2e8ap136099jsn3cdae7586830',
          'X-Rapidapi-Host': 'anime-db.p.rapidapi.com'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final films = <String, String>{};

      for (final film in data) {
        final title = film['title'] as String;
        final description = film['synopsis'] as String;

        films[title] = description;
      }
      print(films);
      return films;
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }

  void initState(){
    super.initState();
    obtenirFilms().then((value) => setState(() {
      _films = value;
    }));
  }

  List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];

  List<bool> _isExpandedList = List.generate(4, (index) => false);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Films'),
        ),
        drawer: MonDrawer(),
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _toggleExpanded(index);
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _items[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                if (_isExpandedList[index])
                  Container(
                    child: Column(children: [
                      Text(
                        'Contenu ${_items[index]}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      FutureBuilder<Map<String,dynamic>?>(
                        future: obtenirFilms(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String,dynamic>?> snapshot) {
                          if (snapshot.hasData) {
                            return Text('${snapshot.data}');
                          } else if (snapshot.hasError) {
                            return Text(
                                'Une erreur est survenue : ${snapshot.error}');
                          } else {
                            return Text('Chargement en cours...');
                          }
                        },
                      ),
                    ]),
                  ),
              ],
            );
          },
        ));
  }
}
