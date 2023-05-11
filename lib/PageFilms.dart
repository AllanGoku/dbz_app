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

  List<String>? obtenirTitresDesFilms() {
    List<String> result = [];
    _films!.forEach((key, value) {
      print(value['title']);
      result.add(value['title']);
    });
    return result;
  }

  void initState() {
    super.initState();
    obtenirFilms().then((data) {
      setState(() {
        _films = data;
      });
    });
    //print(_films);
    //_titres = obtenirTitresDesFilms();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:MonAppBar(),
        drawer: MonDrawer(),
        body: _films == null
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _films?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                          onTap: () {
                            _toggleExpanded(index);
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _toggleExpanded(index);
                                  },
                                  child: Container(
                                    height: 50,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _films![index]!['title'],
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
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          )));
                },
              ) /**/);
  }
}
